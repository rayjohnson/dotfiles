# Global Claude Code Instructions

## Bash scripts
- Always run `shellcheck <script>` after writing or modifying any bash script and fix all warnings before committing.

## Git discipline — safety rules

- **Never push without stating branch and destination first.** Say what branch and where before running the push command.
- **Never use complex chained git write commands.** One write action per command, simple and readable. No `&&`-chained git operations that modify state.
- **Never commit to main directly.** Always work on a feature branch.
- **After any third-party tool runs, check `git status` before staging or committing anything.** Tools (spec-kitty, etc.) may have made unexpected git changes.
- **Write operations always require approval:** `git add`, `git commit`, `git push`, `git checkout`, `git merge`, `git rebase`, `git rm`, `git reset`.

## Preferred Tools & Auto-Install via Homebrew

Before falling back to Python scripts or sed for file manipulation, check 
for and prefer these tools. If a preferred tool is not installed, suggest 
installing it via Homebrew before proceeding with an inferior alternative.

### File Editing
- **Edit tool** — always first choice for single precise edits
- **fastmod** — bulk pattern replacement across files
  - Check: `which fastmod`
  - Install: `brew install fastmod`
  - Run directly: `fastmod 'pattern' 'replacement' dir/` — do NOT wrap in
    shell scaffolding (2>&1, echo exit codes, etc.) as this breaks pre-approval

### Data Formats
- **jq** — JSON querying and manipulation
  - Check: `which jq`
  - Install: `brew install jq`
  - **NEVER use `python -c`, `python3 -c`, or a Python script to parse or transform JSON — always use jq**
- **yq** — YAML querying and manipulation
  - Check: `which yq`
  - Install: `brew install yq`
  - **NEVER use `python -c`, `python3 -c`, or a Python script to parse or transform YAML — always use yq**
- **yamllint** — YAML validation and linting; always use instead of Python for YAML validation
  - Check: `which yamllint`
  - Install: `brew install yamllint`

### Search
- **ripgrep (rg)** — fast file content search, use before Edit to confirm 
  exact match strings
  - Check: `which rg`
  - Install: `brew install ripgrep`

### Text Replacement
- **sd** — modern sed alternative with sane regex syntax, pre-approved in settings.json
  - Check: `which sd`
  - Install: `brew install sd`

### File Reading & Pagination
- **NEVER use `sed -n 'X,Yp'` to read a line range** — use the Read tool with a line range instead (no Bash, no approval prompt)
- **NEVER use `sed` for file viewing of any kind** — it always requires approval
- To read lines 335–375 of a file: use the Read tool with `view_range: [335, 375]`
- To search for a pattern and see context: use `rg -n 'pattern' file` (pre-approved)

### Behavior
- If a preferred tool is missing, say so and offer to install it via 
  Homebrew before falling back to Python or sed
- Never write a temporary Python script solely to edit or transform files 
  when the above tools are available
- Never use sed — use sd instead for replacements (it is pre-approved and will not prompt)

## Bash Tool — Exit Codes and Output Capture

Claude Code's Bash tool automatically returns stdout, stderr, and the exit
code as part of every tool result. Therefore:
- Never append `echo "exit: $?"` — the exit code is already available
- Never use `2>&1` to capture stderr — it is already captured separately
- Never use `2>/dev/null` to suppress stderr — stderr is already captured separately
- Never use `xargs` to chain commands — run commands discretely or use native tool alternatives
- Never wrap commands in diagnostic scaffolding just to observe results
- Run commands directly: `fastmod 'a' 'b' src/` not `fastmod 'a' 'b' src/ 2>&1 && echo $?`
- Wrapping pre-approved tools in shell expressions breaks pattern matching
  and causes unnecessary approval prompts

## File Editing — Approval Avoidance

The Edit and Write tools require NO Bash execution and NO approval prompts.
Bash-based tools ALL require approval unless pre-approved in settings.json.

### Decision rule — follow strictly:
1. Single location edit → use Edit tool directly. Never use Bash.
2. Whole file rewrite → use Write tool. Never use Bash.
3. Bulk edits across multiple files → use Edit tool in a loop across
   files. Still no Bash.
4. Only use sd or fastmod when regex pattern matching is genuinely
   required AND the Edit tool cannot work. Both are pre-approved.

### The key insight:
Even well-intentioned tools like sd and fastmod go through Bash and
would normally trigger approval prompts — but sd, rg, jq, yq, and
fastmod are pre-approved in settings.json so they will not prompt.
The Edit tool never prompts regardless. Always prefer Edit first.

### When to use Edit tool vs sd:
- Single line replacement → sd is fine and pre-approved
- Multiline pattern (match spans a newline) → Edit tool only, sd will fail
- Uncertain whether pattern is single or multiline → Edit tool to be safe

### What Edit needs to work well:
- Read the file first to get the exact string before attempting an Edit
- Use rg to locate exact content if uncertain about surrounding text
- Make multiple small Edit calls rather than one complex Bash command
- Never construct a Bash command to handle uncertainty — Read first, then Edit


## chezmoi
- `~/.claude/CLAUDE.md` is managed by chezmoi. After any change to this file, offer to run `chezmoi add ~/.claude/CLAUDE.md` to sync it.
- Always edit the real deployed file (e.g. `~/.chezmoi_wrapper.zsh`), never the chezmoi source directory file (e.g. `~/.local/share/chezmoi/dot_chezmoi_wrapper.zsh`). Then offer to run `chezmoi re-add` to sync it back.

## Spec Kitty
- Always use `spec-kitty <command>` CLI to query mission, lane, and WP state
- Never grep through `.kittify/` or `kitty-specs/` directly to discover state — use the CLI
- Run `spec-kitty help` if unsure what command to use for a given query
