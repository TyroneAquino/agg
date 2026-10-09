# Demo video

**File:** [`demo`](https://github.com/TyroneAquino/agg/releases/tag/v1)
**Length:** 9:23
**Recorded on:** Desktop
**Google Drive Link:** https://drive.google.com/file/d/1FTyRONaaTjsCGN8DHvIBW4UphVwK8Aed/view?usp=drive_link

## What it shows

A short list, in order, so a viewer can skip to what they need:

- 0:00 **PRESENTATION**
- 0:09 about the app
- 0:22 goal of the app
- 0:40 how the app works
- 0:54 **LIVE DEMO**
- 0:59 main screen
- 1:09 anime minigame tutorial
- 2:37 character minigame tutorial
- 2:57 soundtrack minigame tutorial
- 3:50 device switching
- 5:11 daily mode and practice mode
- 0:00 **PRESENTATION AGAIN**
- 5:40 ai usage
- 7:23 problems on developing the app
- 8:57 future of agg

Cover, in this order: the main user journey end to end, anything that only works
on a real device (camera, GPS, sensors), and the thing you are proudest of.

## Getting it into the repo

GitHub **blocks any file over 100 MB** and warns over 50 MB, so compress before
you commit:

```bash
ffmpeg -i raw.mp4 -vcodec libx264 -crf 28 -preset slow \
       -vf scale=-2:720 -acodec aac -b:a 96k demo.mp4
```

Raise `-crf` (28 to 32) or drop to `-2:480` if it is still too large. If it still
does not fit, attach it to a **GitHub Release** or upload it unlisted and link it
here. Never commit the raw capture: git keeps it forever even after you delete
it.

## Before you record

- Real data off the screen: no classmates' names, numbers, faces or messages.
- Notifications off.
- Sensible sample data, not "asdf".
- One unbroken take per feature. Say what you are doing while you do it.
