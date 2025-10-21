# Tube-Archivist Scripts

Small collection of Bash helpers used to prepare offline / archived YouTube videos for import into TubeArchivist. Written for Debian-like systems; should work in other Linux distributions with Bash and standard GNU utilities.

---

## Goal
Normalize filenames and create accompanying metadata (.info.json) so TubeArchivist can ingest local archives (especially those from archive.org or other offline sources).

Example input filename:
`20170311 (5XtCZ1Fa9ag) Terry A Davis Live Stream.mp4`

Resulting filename and sidecar JSON:
- `20170311 Terry A Davis Live Stream [5XtCZ1Fa9ag].mp4`
- `20170311 Terry A Davis Live Stream [5XtCZ1Fa9ag].info.json`

---

## How it works / Usage
1. Put all the scripts in the directory with your video files (scripts currently do not recurse into subdirectories).
2. Run them in order from the directory containing your media:

```sh
bash convert-()-to-[].bash
bash move-[id]-to-end.bash
bash create-json-alongside.bash
bash insert-id-into-json.bash
bash insert-title-into-json.bash
bash insert-date-into-json.bash
```

Each script performs a single transformation so you can inspect results between steps.

---

## Scripts (order and purpose)
1. `convert-()-to-[].bash`  
   - Replace parentheses containing an ID with square brackets (e.g. `(ID)` -> `[ID]`) and clean spacing.

2. `move-[id]-to-end.bash`  
   - Ensure the video ID appears at the end of the filename inside square brackets.

3. `create-json-alongside.bash`  
   - Create an empty `.info.json` file for each video filename (sidecar).

4. `insert-id-into-json.bash`  
   - Populate the sidecar JSON with the video ID field.

5. `insert-title-into-json.bash`  
   - Insert the cleaned title into the sidecar JSON.

6. `insert-date-into-json.bash`  
   - Insert the date (if available) into the sidecar JSON.

---

## Notes and tips
- Scripts do not process subdirectories. Run at the directory root for each archive.
- Always test on a copy or run a subset first to confirm behavior.
- If filenames contain unusual characters, run a quick grep for non-ASCII prior to processing.
- Modify scripts to add dry-run mode if you want safer previews.

---

## Example archive
Archive used for testing:  
`https://archive.org/details/TempleOS-TheMissingVideos`

Processed example (after running full pipeline):  
`20170311 Terry A Davis Live Stream [5XtCZ1Fa9ag].mp4`  
`20170311 Terry A Davis Live Stream [5XtCZ1Fa9ag].info.json`

---
