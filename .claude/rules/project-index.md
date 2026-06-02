---
paths:
  - "**/*"
---

# Keep PROJECT-INDEX.md in sync

`PROJECT-INDEX.md` (repo root) is the map of this project — the file tree plus what each file is for.

When you **add, remove, rename, or move** any file or directory — or **materially change a file's purpose** — update `PROJECT-INDEX.md` in the **same** change so the map stays accurate. Also update `CLAUDE.md`'s *Material* list if the change affects it.

Routine content edits (fixing a typo, rewording a note, tweaking a question) do **not** require an index update — only structural changes or a changed purpose do.

This is a guideline loaded as context, not an enforced action. It is the deliberate counterpart to a hook: the update needs judgment (only the model can write the right one-line purpose), so it lives as a rule rather than a `PostToolUse` script.
