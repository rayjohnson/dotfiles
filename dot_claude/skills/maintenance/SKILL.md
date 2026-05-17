---
description: Periodic maintenance checklist — chezmoi sync, Home Assistant battery checks, and other housekeeping tasks
disable-model-invocation: true
---

Run the data-gathering scripts up front in a single Bash call, then work through each section interactively. Do not dump raw script output — synthesize findings into readable summaries. Do NOT announce that you are running the scripts — no preamble text before the tool calls. Go silent until the summary is ready.

```bash
bash ~/.claude/skills/maintenance/chezmoi-diff.sh && bash ~/.claude/skills/maintenance/ha-check.sh && bash ~/.claude/skills/maintenance/brew-check.sh
```

Also load the Things3 project todos (project UUID `RfJjvE5sSgMh1gn8Xmtc3w`):
use `mcp__1mcp__things3_1mcp_get_todos` with that UUID.

---

## Report

Present all findings first as a clean summary (batteries, unavailable infra, firmware, chezmoi files, homebrew outdated packages). Then work through each actionable group interactively, one at a time, in this order:

---

## Interactive: Chezmoi

Ask: **"Want to tackle the chezmoi files?"**

If yes, go through each modified file one at a time:
- Show the diff for the file (paste it as a code block)
- Briefly describe what changed (one line)
- Ask: **"y/n?"** (y = re-add, n = skip)
- If y: run `chezmoi re-add <file>` and confirm it worked
- Move to the next file

---

## Interactive: Homebrew

If nothing is outdated, skip this section entirely.

Otherwise, list the outdated packages (name and version bump), give a one-line opinion on whether it's worth doing now (e.g. "all routine patch bumps — safe" vs "includes a major Docker version — worth a quick check"), then ask: **"Want to run brew upgrade?"**

If yes: run `brew upgrade` (this may take a minute) and report what was upgraded.

---

## Interactive: Firmware Updates

For each pending firmware update found by ha-check.sh:

Ask: **"Want to trigger the [name] update now?"**

If yes: run the script — it checks for an in-progress update and skips if one is already running, otherwise kicks it off and returns immediately (HA restarts in the background):
```bash
bash ~/.claude/skills/maintenance/ha-install-update.sh <entity_id>
```

---

## Interactive: Broken HA Infrastructure

Go through each unavailable infrastructure item one at a time (skip companion-app sensors, skip unnamed/stale entities — focus on gateways, integrations, and named devices that are genuinely broken):

For each item:
- Name the device and briefly describe the issue (one line)
- Cross-reference against the Things3 Home Automation project todos already loaded:
  - If a matching task already exists: show it with 📋 and the existing task title — no action needed, move to next item
  - If not tracked: ask **"y/n?"** (y = add to Things3, n = skip)
  - If y: use `mcp__1mcp__things3_1mcp_add_todo` with `list_title: "Home Automation"` and confirm it was added
- Move to the next item

---

## Final Summary

After all interactive steps, give a brief one-paragraph wrap-up of what was done and what remains open.
