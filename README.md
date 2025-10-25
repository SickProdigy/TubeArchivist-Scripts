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
2. Edit 'Example.info.json'
  Update these lines
    - "channel_id": "Change To Channel ID/username",
    - "uploader": "Youtube Username",
    - "uploader_id": "Change To Channel ID",
    - "uploader_url": "https://www.youtube.com/channel/ChangeToChannelID-or-username",
3. Run the scripts in order from the directory containing your media below:

Each script performs a single transformation so you can inspect results between steps.

## Scripts (order and purpose)
1a. `convert-()-to-[].bash`  
   - Replace parentheses containing an ID with square brackets (e.g. `(ID)` -> `[ID]`) and clean spacing.
   - If already have id at end skip to 3. 

1b. `move-find-id-to-end-filename.bash`
   - Split filename into parts. Find id between second and third " - " without brackets, adds backets, moves [id] to end of filename before extension.
   - Skip 1a/2a, straight to 3.

2a. `move-[id]-to-end-filename.bash`  
   - Ensure the video ID appears at the end of the filename inside square brackets.

3. `create-json-alongside-each-file.bash`  
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
- ElasticSearch Common Commands for updates: https://gitea.rcs1.top/sickprodigy/TubeArchivist-Scripts/src/branch/main/ElasticSearch-Common-Commands.md

---

## Example archive
Archive used for testing:  
`https://archive.org/details/TempleOS-TheMissingVideos`

Processed example (after running full pipeline):  
`20170311 Terry A Davis Live Stream [5XtCZ1Fa9ag].mp4`  
`20170311 Terry A Davis Live Stream [5XtCZ1Fa9ag].info.json`

---
