---
name: ui-wireframe
description: Create or update a wireframe + spec before any UI implementation. Use at the start of every non-trivial UI task.
---

# /ui-wireframe

Start the Spillwave UI Guard wireframe-first flow.

1. Identify the screen or feature being changed.
2. Create or update `wireframes/<feature>/` using `wireframes/_template.md` (or this plugin's `templates/wireframes/screen-skeleton.md`).
3. Required sections: Goal / Screen, Layout, Key Elements, States, Acceptance criteria.
4. Create or update the matching spec (`wireframes/<feature>/spec.md` or `docs/specs/<feature>.md`).
5. Stop. Do not write implementation code until the contract exists.

Use the `ui-require-wireframe` and `ui-standards` skills.
