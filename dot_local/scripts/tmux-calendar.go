package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"time"
)

type CalendarEvent struct {
	Summary string `json:"summary"`
	Start   struct {
		DateTime string `json:"dateTime"`
		Date     string `json:"date"`
	} `json:"start"`
}

type CalendarResponse struct {
	Items []CalendarEvent `json:"items"`
}

func loadEnv() map[string]string {
	env := make(map[string]string)
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return env
	}

	envFile := filepath.Join(homeDir, ".env")
	file, err := os.Open(envFile)
	if err != nil {
		return env
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		parts := strings.SplitN(line, "=", 2)
		if len(parts) == 2 {
			key := strings.TrimSpace(parts[0])
			value := strings.Trim(strings.TrimSpace(parts[1]), "\"'")
			env[key] = value
		}
	}

	return env
}

func getCalendarEvents() string {
	env := loadEnv()
	apiKey := env["GOOGLE_STUDIO_APIKEY"]
	if apiKey == "" {
		return "🗓️ No API key"
	}

	now := time.Now()
	endTime := now.Add(4 * time.Hour)

	// Format times for API (RFC3339)
	timeMin := now.Format(time.RFC3339)
	timeMax := endTime.Format(time.RFC3339)

	// Build API URL
	baseURL := "https://www.googleapis.com/calendar/v3/calendars/primary/events"
	params := url.Values{}
	params.Set("key", apiKey)
	params.Set("timeMin", timeMin)
	params.Set("timeMax", timeMax)
	params.Set("singleEvents", "true")
	params.Set("orderBy", "startTime")
	params.Set("maxResults", "3")

	fullURL := baseURL + "?" + params.Encode()

	// Make API request
	client := &http.Client{Timeout: 5 * time.Second}
	resp, err := client.Get(fullURL)
	if err != nil {
		return "🗓️ Network error"
	}
	defer resp.Body.Close()

	if resp.StatusCode == 401 {
		return "🗓️ Auth error"
	}
	if resp.StatusCode != 200 {
		return fmt.Sprintf("🗓️ API error (%d)", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "🗓️ Read error"
	}

	var calResp CalendarResponse
	if err := json.Unmarshal(body, &calResp); err != nil {
		return "🗓️ Parse error"
	}

	if len(calResp.Items) == 0 {
		return "🗓️ No meetings"
	}

	var upcoming []string
	for _, event := range calResp.Items {
		if len(upcoming) >= 2 {
			break
		}

		title := event.Summary
		if title == "" {
			title = "Untitled"
		}

		// Only process timed events (not all-day)
		if event.Start.DateTime == "" {
			continue
		}

		// Parse start time
		startTime, err := time.Parse(time.RFC3339, event.Start.DateTime)
		if err != nil {
			continue
		}

		timeDiff := startTime.Sub(now)
		if timeDiff < 0 || timeDiff > 4*time.Hour {
			continue
		}

		minutesUntil := int(timeDiff.Minutes())

		var status string
		if minutesUntil <= 5 {
			status = "🔴 NOW"
		} else if minutesUntil <= 15 {
			status = fmt.Sprintf("🟡 %dm", minutesUntil)
		} else {
			status = fmt.Sprintf("🟢 %s", startTime.Format("15:04"))
		}

		// Truncate long titles
		if len(title) > 15 {
			title = title[:15] + "..."
		}

		upcoming = append(upcoming, fmt.Sprintf("%s %s", status, title))
	}

	if len(upcoming) > 0 {
		return strings.Join(upcoming, " | ")
	}

	return "🗓️ No meetings"
}

func main() {
	fmt.Print(getCalendarEvents())
}