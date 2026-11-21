# Elevation RL Text to AutoCAD 3D Points (AutoLISP)

An AutoLISP utility for converting **numeric MTEXT elevation labels (RL values)** in an AutoCAD drawing into **3D POINT entities**. Each new point uses the MTEXT insertion point's X/Y location and the text's numerical value as its Z (elevation).

This can help prepare CAD elevation point data for subsequent terrain-surface or contour workflows. **The routine does not create contours, a surface, or a GIS dataset by itself.**

## What is included

| File | Description |
| --- | --- |
| `Create3DPointsFromMovedMText.lsp` | Original AutoLISP routine; command: `MTextTo3DPoints` |
| `Moved_RL_Texts_and_3DPonts_wth_Grid.dwg` | Provided AutoCAD example drawing |
| `docs/TESTING.md` | Suggested verification steps and important limitations |

## How it works

1. Searches the **current drawing tab** for all MTEXT objects.
2. Reads each MTEXT object's `TextString` and insertion coordinates.
3. Attempts to parse the text as a numeric elevation using `distof`.
4. For successfully parsed values, creates an AutoCAD `POINT` with X/Y from the label position and Z from the elevation.
5. Skips text that cannot be parsed as a number.

**Illustrative example:** An MTEXT label containing `12.75` at an insertion point of `(500.00, 600.00)` produces a 3D point at `(500.00, 600.00, 12.75)` when the label parses as a valid numeric value.

## Requirements

- AutoCAD with AutoLISP and Visual LISP/ActiveX support (the script calls `vl-load-com` and `vlax-...` functions; typically this means compatible AutoCAD on Windows).
- A DWG containing **plain numeric MTEXT** elevation labels positioned at the intended XY locations.
- Appropriate drawing units, coordinate reference and elevation conventions established in the source drawing.

**Status:** The original script is published here as supplied. This documentation describes the inspected source; this repository update is **not a claim of new AutoCAD runtime testing**.

## Installation and use

1. **Make a backup of the DWG** before testing the command. Running it again can create duplicate points.
2. Open the drawing in a compatible AutoCAD installation.
3. Enter `APPLOAD` and load `Create3DPointsFromMovedMText.lsp`.
4. Activate the drawing tab (model or layout) containing the elevation labels.
5. Enter `MTextTo3DPoints` on the command line.
6. Inspect the resulting point elevations using AutoCAD Properties or `LIST`. Check the point positions before using them for terrain processing.

If POINT markers are difficult to see, review AutoCAD's `PDMODE` and `PDSIZE` display settings, then use `REGEN` if necessary.

## Important limitations

- The original routine processes **all MTEXT in the active tab**, not only selected labels. Non-elevation numeric annotations could also generate points.
- It does not recognize `TEXT`, blocks, attributes or survey files.
- It assumes an MTEXT label contains a parseable numeric value. Units, prefixes/suffixes, multiline text, formatting codes or locale-specific decimal separators may need preprocessing.
- Coordinates come from the **MTEXT insertion point**, which must represent the intended elevation point location. The program does not infer the correct position from a leader or nearby symbol.
- The source drawing's coordinate system and elevation datum are not validated by the script.
- The original routine provides a success message but **does not report counts** of created and skipped labels.
- It does not remove or modify source MTEXT; it only adds point entities.
- Re-running the command can create duplicate points. Undo or restore the backup if the output is incorrect.
- A 3D point output is not evidence of surveying accuracy; the result inherits the accuracy of the input label and its placement.

## Recommended validation

See [the test checklist](docs/TESTING.md) for a small controlled test covering positive/negative elevations, invalid labels, X/Y alignment, Z values, point visibility and repeat runs.

## Intended applications

- Preparing elevation point data from legacy CAD labels
- Supporting subsequent 3D terrain modelling
- CAD-to-GIS elevation-data preparation, after independent verification and conversion

## Repository notes

This project demonstrates **practical AutoCAD/AutoLISP automation**. It is not a Python or GIS application programming framework. If you reuse this code for production work, validate it with your AutoCAD version and drawing conventions.

**Author:** Lutfor Rahman — Senior GIS Specialist | ArcGIS Mapping, Geodatabase & Web GIS.
