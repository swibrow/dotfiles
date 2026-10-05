# Pull request helpers: `just -g gh pr <recipe>`.

# Watch CI checks on the current branch's PR (or a given PR number/url/branch)
[no-cd]
watch *pr:
    gh pr checks {{ pr }} --watch
