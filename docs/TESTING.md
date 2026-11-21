# AutoCAD Verification Checklist

The original `MTextTo3DPoints` command has been reviewed from its source, but not executed in AutoCAD as part of these documentation changes. Test on a **copy** of a drawing before using it in a project.

## Prepare a controlled drawing

Create MTEXT objects on the current tab with these representative values, at known insertion points:

| MTEXT | Expected behavior |
| --- | --- |
| `12.75` | Create a 3D point with Z = 12.75 |
| `0` | Create a 3D point with Z = 0 |
| `-3.50` | Create a 3D point with Z = -3.50 |
| `ABC` | Skip; not a numerical elevation |
| `RL 12.75` | Treat as unsupported unless preprocessing is implemented |
| Empty or formatted/multiline MTEXT | Review parsing behavior; do not assume it is supported |

For each numeric label, record its intended insertion X/Y and the resulting point X/Y/Z.

## Test procedure

1. Save a copy of the DWG and note its units and elevation datum.
2. Load `Create3DPointsFromMovedMText.lsp` via `APPLOAD`.
3. Run `MTextTo3DPoints` on the tab containing the controlled labels.
4. Count newly created POINT entities and inspect their coordinates with `LIST` or the Properties palette.
5. Confirm each point's X/Y matches the corresponding MTEXT insertion coordinates and its Z matches the parsed value.
6. Confirm non-numeric labels do not create points.
7. Confirm the original MTEXT was not altered.
8. Check another drawing tab to confirm the command scans only the active tab.
9. Restore the backup or undo before re-running: the routine does not deduplicate points.
10. Record the AutoCAD version, input examples, actual point counts, discrepancies, and screenshots.

## Production-quality considerations

- A future version should offer selection-set processing rather than blindly processing all MTEXT.
- It should report created/skipped counts and check the return value of `entmake`.
- It should consider text formatting and decimal separators explicitly.
- Input annotations must be spatially located at the intended elevation points.
- Test any enhanced version separately before replacing the original script.
