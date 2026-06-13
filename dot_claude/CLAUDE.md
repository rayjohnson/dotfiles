# Global Claude Code Instructions

## Bash scripts
- Always run `shellcheck <script>` after writing or modifying any bash script and fix all warnings before committing.

## Git commits
- Never add a "Co-Authored-By:" trailer to commit messages.

## Preferred Tools & Auto-Install via Homebrew

Before falling back to Python scripts or sed for file manipulation, check 
for and prefer these tools. If a preferred tool is not installed, suggest 
installing it via Homebrew before proceeding with an inferior alternative.

### File Editing
- **Edit tool** — always first choice for single precise edits
- **fastmod** — bulk pattern replacement across files
  - Check: `which fastmod`
  - Install: `brew install fastmod`

### Data Formats
- **jq** — JSON querying and manipulation
  - Check: `which jq`  
  - Install: `brew install jq`
- **yq** — YAML querying and manipulation
  - Check: `which yq`
  - Install: `brew install yq`

### Search
- **ripgrep (rg)** — fast file content search, use before Edit to confirm 
  exact match strings
  - Check: `which rg`
  - Install: `brew install ripgrep`

### Text Replacement
- **sd** — modern sed alternative with sane regex syntax
  - Check: `which sd`
  - Install: `brew install sd`

### Behavior
- If a preferred tool is missing, say so and offer to install it via 
  Homebrew before falling back to Python or sed
- Never write a temporary Python script solely to edit or transform files 
  when the above tools are available
- Never use sed when fastmod or sd would be clearer and safer


## chezmoi
- `~/.claude/CLAUDE.md` is managed by chezmoi. After any change to this file, offer to run `chezmoi add ~/.claude/CLAUDE.md` to sync it.
- Always edit the real deployed file (e.g. `~/.chezmoi_wrapper.zsh`), never the chezmoi source directory file (e.g. `~/.local/share/chezmoi/dot_chezmoi_wrapper.zsh`). Then offer to run `chezmoi re-add` to sync it back.
