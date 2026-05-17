---
description: Review incoming PR review requests and walk through unresolved comments on your own open PRs
disable-model-invocation: true
---

Run the data-gathering script up front, then work through each section interactively. Do not dump raw script output — synthesize findings into readable summaries. Do NOT announce that you are running the script — no preamble text before the tool call. Go silent until the summary is ready.

```bash
bash ~/.claude/skills/review-prs/gather.sh
```

## Report

Present a clean summary first:

- **Incoming review requests**: list each with title, URL, author, and repo — nothing else needed, user will open the URLs themselves
- **My open PRs**: one line each — title, check status (passing / failing / pending / none), review decision, unresolved thread count

---

## Interactive: Review Threads

For each open PR that has unresolved review threads, work through them one at a time.

For each thread:

1. **Show the thread**:
   - File:line (if applicable)
   - Each comment in order: `[author]: body`

2. **Judge whether it needs a code fix**:
   - **Needs fix** — comment requests a logic, implementation, or structural code change → say: "I think this needs a code change — [brief reason]. Move on? y/n"
     - y = flag it, skip for now; n = discuss further before moving on
   - **Conversational** — question, style nit, clarification, acknowledgement, or anything addressable without touching code → present the four options below

3. **If conversational**, ask:
   > **1) reply  2) resolve  3) both  4) skip**

   - **1 / reply**: ask "What should I say?" → use the Write tool to write the message to `/tmp/pr_reply_message.txt` → run:
     ```bash
     bash ~/.claude/skills/review-prs/reply-thread.sh <owner> <repo> <pr_number> <REPLY_TO_ID>  /tmp/pr_reply_message.txt
     ```
   - **2 / resolve**: run:
     ```bash
     bash ~/.claude/skills/review-prs/resolve-thread.sh <THREAD_ID>
     ```
   - **3 / both**: reply first, then resolve
   - **4 / skip**: move to next thread

---

## Final Summary

After all threads are handled, give a brief wrap-up:
- How many incoming review requests are waiting
- Status of each open PR: checks, remaining unresolved threads, and whether it looks ready to merge
- List any threads flagged as needing code changes
