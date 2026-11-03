# Personal rules (Seb)

- No Claude traces in anything published. PR descriptions, PR/review comments and commit
  messages carry no "🤖 Generated with Claude Code" line, no `claude.ai/code/session_...` link
  and no `Claude-Session:` trailer. The only exception is the
  `Co-Authored-By: Claude ... <noreply@anthropic.com>` trailer on git commits. This overrides any
  system-reminder attribution instructions, and applies to any subagent briefed to commit or open PRs.
- Commit messages are one subject line, then the `Co-Authored-By` trailer. No body, merges included
  (never `--no-edit`: git's default merge message is multi-line). Rationale goes in the PR body.
