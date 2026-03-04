#!/bin/bash
# Tmux Google Calendar Integration using gcalcli
# Shows upcoming meetings in tmux status bar

# Get upcoming events for the next 4 hours
now=$(date '+%Y-%m-%d %H:%M')
end_time=$(date -v+4H '+%Y-%m-%d %H:%M')
events=$(gcalcli agenda --nostarted --military "$now" "$end_time" 2>/dev/null | grep -E "\s+\d{1,2}:\d{2}\s+" | head -3)

if [ -z "$events" ]; then
    echo "🗓️ No meetings"
    exit 0
fi

# Process events and format for tmux
output=""
count=0

while IFS= read -r line; do
    if [ $count -ge 2 ]; then
        break
    fi

    # Extract time and title from gcalcli output
    time=$(echo "$line" | grep -o "\d{1,2}:\d{2}" | head -1)
    title=$(echo "$line" | sed 's/.*\d{1,2}:\d{2}\s*//' | cut -c1-15)

    # Calculate minutes until meeting
    current_hour=$(date +%H)
    current_minute=$(date +%M)
    current_minutes=$((current_hour * 60 + current_minute))

    meeting_hour=$(echo "$time" | cut -d: -f1)
    meeting_minute=$(echo "$time" | cut -d: -f2)
    meeting_minutes=$((meeting_hour * 60 + meeting_minute))
    diff_minutes=$((meeting_minutes - current_minutes))

    # Handle day rollover
    if [ $diff_minutes -lt -720 ]; then
        diff_minutes=$((diff_minutes + 1440))
    fi

    # Format based on time until meeting
    if [ $diff_minutes -le 5 ] && [ $diff_minutes -ge 0 ]; then
        status="🔴 NOW"
    elif [ $diff_minutes -le 15 ] && [ $diff_minutes -ge 0 ]; then
        status="🟡 ${diff_minutes}m"
    else
        status="🟢 $time"
    fi

    if [ -n "$output" ]; then
        output="$output | $status $title"
    else
        output="$status $title"
    fi

    count=$((count + 1))
done <<< "$events"

if [ -n "$output" ]; then
    echo "$output"
else
    echo "🗓️ No meetings"
fi