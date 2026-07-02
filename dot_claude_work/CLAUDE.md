Only create .yaml for yaml files

Don't add inline comments to code unless it's genuinely complex and the code can't speak for itself. Prefer clear names and structure over explanatory comments.

## Containers

Use `container` instead of `docker` for building and running containers. Instead of `docker compose`, use a kind cluster for multi-service local environments.

# Bug / Feature Tracker Workflow

When working on a task and you discover a **bug** or identify a **feature/improvement**
that is needed (but is out of scope for the current change), file it as a GitHub issue
and add it to the DND-IT "Bug and Feature Tracker" project board:

  https://github.com/orgs/DND-IT/projects/13  (org: DND-IT, project number: 13)

## When to file

- A genuine bug discovered while working (not the one you're already fixing).
- A feature or improvement that the current work reveals is needed.
- Do **not** file noise: trivial nits, things already tracked, or work you're about
  to do in the current change.

## How to file

Create the issue in the repo you're working on, then add it to the board:

```bash
# 1. Create the issue (capture the URL it prints)
url=$(gh issue create \
  --repo DND-IT/<repo> \
  --title "<concise title>" \
  --label bug \  # or: --label enhancement
  --body "<what, where (file:line), why it matters, suggested fix>")

# 2. Add it to the Bug and Feature Tracker board
gh project item-add 13 --owner DND-IT --url "$url"
```

New items land in the board's **To triage** status by default — leave triage/sizing
to the board owner.

## Notes

- `gh` must be authenticated with the `project` scope (already configured).
- Default `--repo` to the current repository; if it's not a DND-IT platform repo,
  ask before filing.
- Mention the filed issue URL in your reply so it's visible in the conversation.

<!-- newsagent:begin -->
@/Users/bcfd@mediait.ch/.newsagent/standards/bug-feature-tracker.md
<!-- newsagent:end -->
