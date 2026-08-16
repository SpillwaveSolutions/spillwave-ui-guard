# Recommended Workflow

## For a new UI feature or major change

```
1. Create feature branch
2. Write / update wireframe(s) under wireframes/<feature>/
   - Include acceptance criteria
3. (Optional) Write a short spec.md
4. Implement the UI
5. Start the app (dev server and/or Tauri)
6. Run adversarial review (ui-adversarial-reviewer skill)
7. Fix any FAIL items
8. Re-run review until PASS
9. Update visual baselines if the change was intentional
10. Commit (pre-commit hook will remind if wireframes were skipped)
11. Open PR
```

## Roles

| Role     | Responsibility                                      |
|----------|-----------------------------------------------------|
| Builder  | Wireframe → implement                               |
| Critic   | Adversarial review against wireframe + criteria     |

Prefer different sessions or explicit role switches so the critic is not biased by having written the code.

## Definition of Done (UI)

- Wireframe current
- Spec current (if non-trivial)
- Implementation matches acceptance criteria
- Adversarial review = PASS (or accepted PASS WITH NOTES)
- No new console errors on the reviewed paths
- Visual baselines updated when appropriate
