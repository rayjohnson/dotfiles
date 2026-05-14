# Global Claude Code Instructions

## Bash scripts
- Always run `shellcheck <script>` after writing or modifying any bash script and fix all warnings before committing.

## Git commits
- Never add a "Co-Authored-By:" trailer to commit messages.

## chezmoi
- `~/.claude/CLAUDE.md` is managed by chezmoi. After any change to this file, offer to run `chezmoi add ~/.claude/CLAUDE.md` to sync it.
