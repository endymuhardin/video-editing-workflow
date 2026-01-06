# Sync Workflow: Separate Camera + Screen Recording

## Overview

Record camera and screen separately, sync in DaVinci Resolve using audio waveform matching.

```
Nikon ZFC (SD Card)              MacBook (QuickTime/OBS)
      ↓                                  ↓
   .MOV file                         .MOV file
      ↓                                  ↓
  01-raw/camera/                   01-raw/screen/
            ↘                      ↙
              DaVinci Resolve
                    ↓
           Auto-Sync (Waveform)
                    ↓
              Synced Timeline
```

## Recording Setup

### Camera (Nikon ZFC)

```
Recording settings:
  Resolution:     1920x1080
  Frame rate:     30fps (match screen recording)
  Audio:          On (built-in mic is fine for sync reference)

File naming:
  Set date/time correctly for file ordering
```

### Screen (QuickTime Player)

```
File > New Screen Recording
  Microphone:     Built-in or external mic

Options:
  Show Mouse Clicks:    On (optional)

Save to:    01-raw/screen/
```

Or use **OBS** for more control:

```
Scene: Screen Only
  - macOS Screen Capture
  - Audio Input (mic)

Recording:
  Format:     MOV
  Encoder:    Apple VT H265 Hardware
  Path:       01-raw/screen/
```

### Audio Sync Reference

**Critical:** Both recordings must capture the same audio for waveform sync.

Options:
1. **Room audio** - Speak during recording, both mics pick it up
2. **Clap at start** - Sharp audio spike for easy alignment
3. **Music playback** - Play music briefly at start

---

## Sync in DaVinci Resolve

### Method 1: Auto Sync Audio (Recommended)

1. Import both clips to Media Pool
   - Camera footage from `01-raw/camera/`
   - Screen recording from `01-raw/screen/`

2. Select both clips in Media Pool (Cmd+Click)

3. Right-click → **Auto Sync Audio** → **Based on Waveform**

4. DaVinci creates a synced **Multicam Clip** or **Compound Clip**

5. Edit using the synced clip

### Method 2: Manual Sync

1. Create new timeline

2. Place camera on Video Track 1

3. Place screen on Video Track 2

4. Zoom into audio waveforms

5. Find matching audio spike (clap, word, etc.)

6. Align clips at that point

7. Select both → Right-click → **Link Clips**

### Method 3: Sync Bin (Multiple Takes)

For multiple camera+screen pairs:

1. Create bin: "Sync Clips"

2. Select matching pairs (camera + screen from same take)

3. Right-click → **Auto Sync Audio** → **Based on Waveform**

4. Repeat for each pair

---

## Editing Synced Footage

### Multicam Approach

After syncing, use Multicam to switch between views:

1. Right-click synced clip → **New Multicam Clip Using Selected Clips**

2. Set angles:
   - Angle 1: Camera (talking head)
   - Angle 2: Screen recording

3. In timeline, enable **Multicam View**

4. Play and click to switch angles in real-time

5. Fine-tune cuts afterward

### Manual Cutting

1. Place synced compound clip on timeline

2. Open in Fusion or use Transform to:
   - Full camera (talking head)
   - Full screen
   - Screen + camera overlay (picture-in-picture)

3. Blade tool (Cmd+B) to cut between views

4. Apply different layouts to each segment

---

## Picture-in-Picture Layout

For screen + camera overlay:

1. Stack on timeline:
   ```
   V2: Camera (overlay)
   V1: Screen (full)
   ```

2. Select camera clip (V2)

3. Inspector → Transform:
   ```
   Zoom:       0.25 (25% size)
   Position X: 0.37 (right side)
   Position Y: -0.35 (bottom)
   ```

4. Optional: Add drop shadow or border

Save as preset: **PiP Bottom Right**

---

## Auto-Editor with Synced Footage

Auto-editor works best with single files. Two options:

### Option A: Export Synced Clip, Then Auto-Edit

1. Sync in DaVinci
2. Export synced timeline as single file (ProRes)
3. Run auto-edit.sh on exported file
4. Re-import XML for final edit

### Option B: Manual Edit (Skip Auto-Editor)

1. Sync in DaVinci
2. Use DaVinci's built-in tools:
   - **Scene Cut Detection** for rough cuts
   - **Auto Subtitles** (transcription-based editing)
3. Manually remove pauses

### Option C: Auto-Edit Screen Only

1. Run auto-edit.sh on screen recording only
2. Import XML to DaVinci
3. Manually sync camera to the edited screen timeline

---

## Folder Structure

```
project/
├── 01-raw/
│   ├── camera/
│   │   └── DSC_0001.MOV         # From Nikon SD card
│   └── screen/
│       └── Screen Recording.mov  # From QuickTime/OBS
├── 03-project/
│   └── davinci/
│       └── project.drp          # Synced timeline here
```

---

## Checklist

Before recording:
- [ ] Camera and laptop clocks synchronized (roughly)
- [ ] Same frame rate on both (30fps)
- [ ] Audio enabled on both devices

During recording:
- [ ] Clap or audio cue at start
- [ ] Speak clearly (helps waveform sync)

After recording:
- [ ] Copy camera footage to 01-raw/camera/
- [ ] Move screen recording to 01-raw/screen/
- [ ] Sync in DaVinci before editing
