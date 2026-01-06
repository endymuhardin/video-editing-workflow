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

### Audio: Hollyland Lark M2

Connect Lark M2 to **laptop** (not camera):

```
Lark M2 TX (transmitter) → Clip to shirt
Lark M2 RX (receiver)    → USB-C extension (15cm) → MacBook
                                                        ↓
                                        Screen recording captures primary audio

Camera built-in mic      → Captures room audio for sync reference
                            (muted in final edit)
```

**USB-C extension cable:** The Lark M2 receiver is long and blocks the adjacent USB-C port on MacBook. Use a short 15cm USB-C extension cable.

**Why laptop, not camera:**
- USB-C = clean digital signal (no analog noise)
- MacBook audio input > Nikon 3.5mm preamp
- Primary audio on the track you'll actually use
- Camera audio only needed for waveform sync

### Camera (Nikon ZFC)

```
Recording settings:
  Resolution:     1920x1080
  Frame rate:     30fps (match screen recording)
  Audio:          ON (built-in mic for sync reference only)

File naming:
  Set date/time correctly for file ordering
```

**Important:** Keep camera audio ON even though you'll mute it later. It's needed for waveform sync.

### Screen (QuickTime Player)

```
File > New Screen Recording

Click dropdown arrow next to record button:
  Microphone:     Hollyland Lark M2

Options:
  Show Mouse Clicks:    On (optional)

Save to:    01-raw/screen/
```

### Screen (OBS - Recommended)

More control over audio levels and format:

```
Scene: Screen Only
  - macOS Screen Capture
  - Audio Input: Hollyland Lark M2

Settings > Audio:
  Mic/Auxiliary Audio:  Hollyland Lark M2
  Sample Rate:          48 kHz

Recording:
  Format:     MOV
  Encoder:    Apple VT H265 Hardware
  Path:       01-raw/screen/
```

### Audio Sync Reference

**How waveform sync works with Lark M2 setup:**

```
Your voice → Lark M2 → Screen recording (loud, clear)
          ↘
           → Camera built-in mic (quieter, room ambience)

Both recordings have your voice → DaVinci matches waveforms
```

**Tips for reliable sync:**
1. Speak clearly at the start (helps sync algorithm)
2. Clap once at the beginning (sharp spike = easy visual alignment)
3. Keep camera audio gain reasonable (not too quiet)

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
