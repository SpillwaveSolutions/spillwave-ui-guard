---
name: ui-review
description: Run an adversarial review of the running UI against wireframe acceptance criteria. Builder must not self-approve.
---

# /ui-review

Run the Spillwave UI Guard critic pass.

1. Switch into critic mode (builder ≠ reviewer).
2. Follow the `ui-adversarial-reviewer` skill.
3. Launch or connect to the running app.
4. Check every acceptance criterion in the matching wireframe.
5. Optionally run `ui-accessibility-check` and `ui-visual-regression`.
6. Emit PASS / PASS WITH NOTES / FAIL with evidence.

Do not mark the UI work done without a PASS or an accepted PASS WITH NOTES.
