# DaVinci Resolve Project Settings

**Target Version:** DaVinci Resolve 20.x (Studio features noted)
**Platform:** MacBook Pro M1 (Apple Silicon)

## Quick Setup

1. Open DaVinci Resolve
2. Create new project
3. File > Project Settings (Shift+9)
4. Apply settings below
5. Save as preset: "YouTube Tutorial 1080p"

---

## Master Settings (Timeline)

### Timeline Format
```
Timeline resolution:    1920 x 1080 HD
Timeline frame rate:    30 fps (match your camera)
Playback frame rate:    30 fps
```

### Video Monitoring
```
Video format:           HD 1080p 30
Video bit depth:        10-bit (if supported)
Video data levels:      Full
```

---

## Image Scaling

### Input Scaling
```
Mismatched resolution:  Scale full frame with crop
                        (centers and crops 4K to 1080p)
```

### Output Scaling
```
Mismatched resolution:  Scale full frame with crop
```

---

## Color Management

### Color Science
```
Color science:          DaVinci YRGB
Timeline color space:   Rec.709 Gamma 2.4
Output color space:     Rec.709 Gamma 2.4
```

For Nikon ZFC footage (standard profile):
```
No LUT needed for standard picture profile
If using N-Log: Apply Nikon N-Log to Rec.709 LUT
```

---

## Optimized Media & Render Cache (M1)

### Optimized Media
```
Optimized media resolution:    Original (M1 handles 1080p natively)
Optimized media format:        ProRes 422 LT
Render cache format:           ProRes 422 LT
Enable background caching:     Yes
```

Note: M1 handles 1080p ProRes/H.265 without proxies. Only generate proxies for 4K+ footage.

### Working Folders
```
Proxy media location:          [Project]/02-proxy/
Cache files location:          [Project]/02-proxy/
Gallery stills location:       [Project]/02-proxy/stills/
```

---

## M1 Performance Settings

### GPU Configuration
```
Preferences > System > Memory and GPU:
  GPU processing mode:         Metal
  GPU selection:               Apple M1 (auto-detected)
```

### Memory
```
Preferences > System > Memory and GPU:
  System memory:               Leave at default (macOS manages unified memory)
  GPU memory:                  Auto (shared with system)
```

### Decode Options
```
Preferences > System > Decode Options:
  Use hardware acceleration:   Enabled
  Decode H.264/H.265 using:    Hardware (Apple Media Engine)
```

### Encode Options (Deliver page)
```
Use hardware acceleration:     Enabled (uses Apple Media Engine)

M1 hardware encoding speeds:
  H.264 1080p:    ~5x realtime
  H.265 1080p:    ~4x realtime
  ProRes 422:     ~8x realtime
```

### Playback Settings
```
Preferences > User > Playback Settings:
  Hide UI overlays:            After 3 seconds
  Minimize interface updates:  Enabled (reduces GPU load)
```

### Optimal Timeline Performance
```
Project Settings > Master Settings:
  Timeline playback:           30 fps
  Video bit depth:             8-bit (faster) or 10-bit (color grading)

For smooth playback:
  Playback > Timeline Proxy Mode:  Off (M1 handles 1080p fine)
  Playback > Render Cache:         Smart
```

---

## Audio Settings

```
Audio sample rate:      48000 Hz (48 kHz)
Audio bit depth:        24-bit
```

---

## Capture and Playback

```
Capture:                Use project settings
Playback:               Use project settings
```

---

## Export Presets (M1 Hardware Encoding)

All presets use Apple Media Engine hardware acceleration for fast exports.

### YouTube Master (1080p)

Go to: Deliver page > Custom Export

```
Format:                 QuickTime
Codec:                  H.265 (HEVC)
Encoder:                Apple M1 (hardware)
Resolution:             1920 x 1080
Frame rate:             30
Quality:                Restrict to 25,000 Kb/s

Audio:
  Codec:                AAC
  Bit rate:             320 Kb/s

Advanced:
  Use hardware acceleration: Enabled

File suffix:            _MASTER
Save to:                05-exports/master/
```

Alternative: H.264 for wider compatibility
```
Codec:                  H.264
Encoder:                Apple M1 (hardware)
Quality:                Restrict to 20,000 Kb/s
```

Save preset as: "YouTube 1080p Master"

### YouTube Shorts (Vertical 9:16)

```
Format:                 QuickTime
Codec:                  H.264
Encoder:                Apple M1 (hardware)
Resolution:             1080 x 1920 (note: vertical)
Frame rate:             30
Quality:                Restrict to 15,000 Kb/s

Audio:
  Codec:                AAC
  Bit rate:             256 Kb/s

File suffix:            _SHORT_YT
Save to:                05-exports/shorts/youtube/
```

Save preset as: "YouTube Shorts 1080x1920"

### Instagram Reels (9:16)

```
Format:                 QuickTime
Codec:                  H.264
Encoder:                Apple M1 (hardware)
Resolution:             1080 x 1920
Frame rate:             30
Quality:                Restrict to 12,000 Kb/s

Audio:
  Codec:                AAC
  Bit rate:             256 Kb/s

File suffix:            _SHORT_IG
Save to:                05-exports/shorts/instagram/
```

Note: Instagram max upload 650MB. For 90s clip, 12Mbps is ~135MB.

Save preset as: "Instagram Reels"

### TikTok (9:16)

```
Format:                 QuickTime
Codec:                  H.264
Encoder:                Apple M1 (hardware)
Resolution:             1080 x 1920
Frame rate:             30
Quality:                Restrict to 10,000 Kb/s

Audio:
  Codec:                AAC
  Bit rate:             192 Kb/s

File suffix:            _SHORT_TT
Save to:                05-exports/shorts/tiktok/
```

Note: TikTok max 287MB for <10min videos.

Save preset as: "TikTok"

### M1 Export Time Estimates (1080p, 10-minute video)

```
H.264 hardware:     ~2 minutes
H.265 hardware:     ~2.5 minutes
ProRes 422:         ~1.5 minutes
ProRes 422 LT:      ~1 minute
```

---

## Timeline Presets

### Main Timeline (16:9 Horizontal)
```
Name:                   Main - 1080p 30fps
Resolution:             1920 x 1080
Frame rate:             30 fps
```

### Shorts Timeline (9:16 Vertical)
```
Name:                   Shorts - 1080x1920 30fps
Resolution:             1080 x 1920
Frame rate:             30 fps
```

To create vertical timeline for shorts:
1. Right-click Media Pool > Timelines > Create New Timeline
2. Use Custom Settings
3. Set resolution to 1080 x 1920
4. Import clips from main timeline, reframe as needed

---

## Keyboard Shortcuts (Recommended)

```
Shift + 9           Project Settings
Ctrl/Cmd + B        Blade/Cut
Ctrl/Cmd + Shift + [ Ripple delete
Q                   Toggle source/timeline
J K L               Playback (reverse, pause, forward)
I                   Mark In
O                   Mark Out
Alt + Y             Match frame (find source)
```

---

## Performance Tips

### For smooth 1080p editing:
```
Playback > Proxy Mode:              Half Resolution
Playback > Render Cache:            Smart
Timeline > Optimized Media:         Generate for all clips
```

### GPU Acceleration:
```
Preferences > System > Memory and GPU
GPU processing mode:                CUDA (NVIDIA) / Metal (Mac)
GPU selection:                      Auto
```

---

## Project Backup

### Auto-save
```
Preferences > User > Project Save and Load
Live save:                          Enabled
Project backups:                    Enabled
Backup location:                    [Project]/03-project/davinci/backups/
```

### Manual backup
```
File > Export Project Archive
Save to:                            07-archive/
Include:                            Project only (media referenced, not copied)
```

---

## Importing Auto-Editor XML

1. File > Import > Timeline
2. Select XML from `03-project/auto-editor/`
3. When prompted, link media from `01-raw/`
4. Timeline appears in Media Pool

---

## Lower Third Preset

Create reusable lower third in Fusion:

1. Effects > Toolbox > Titles > Text+
2. Add background shape, animate in/out
3. Right-click > Create Fusion Macro
4. Save to `04-assets/lower-thirds/`
5. Reuse by dragging macro to timeline

Recommended lower third specs:
```
Position:               Bottom left, 10% margin
Font:                   Sans-serif (Roboto, Inter, SF Pro)
Size:                   48-60pt for name, 36-42pt for title
Duration:               3-5 seconds
Animation:              Slide in from left, fade out
```

---

## DaVinci Resolve 20.x AI Features

### Auto Subtitles (Built-in)

Edit page > Timeline menu > Create Subtitles from Audio

```
Language:               Indonesian / English (auto-detect)
Caption preset:         YouTube / Custom
Max characters:         42 per line
Max lines:              2
Gap between subtitles:  0 frames
```

After generation:
1. Review in Timeline > Subtitle track
2. Edit text directly in Inspector
3. Export: Deliver > Subtitle Settings > Export to File (SRT)
4. Save to: `06-captions/`

### Scene Cut Detection

Media Pool > Right-click clip > Scene Cut Detection
- Automatically splits long recordings at scene changes
- Useful for multi-take recordings

### AI Audio Features

**Voice Isolation** (Fairlight page):
1. Select audio clip
2. Effects > Fairlight FX > Voice Isolation
3. Removes background noise, isolates speech

**Dialogue Leveler**:
1. Select audio track
2. Mixer > Dynamics > Dialogue Leveler
3. Normalizes speech volume across cuts

**Auto Ducking** (for background music):
1. Place music on separate track
2. Enable Auto Ducking on music track
3. Automatically lowers music when speech detected

### IntelliTrack (Object Tracking)

Color page > Window > Tracker
- Track faces for color grading
- Track objects for blur/mosaic
- Useful for blurring sensitive info on screen recordings

### Magic Mask

Color page > Magic Mask
- AI-powered subject isolation
- Separate person from background
- Useful for adding background blur to talking head

### Super Scale (Studio)

Project Settings > Image Scaling > Super Scale
- AI upscaling: 2x, 3x, 4x
- Upscale 720p screen recordings to 1080p

### Speed Warp (Studio)

Timeline > Right-click clip > Retime Controls
- Optical Flow: Best for slow motion
- Speed Warp: AI motion estimation for smoother speed changes

---

## Vertical Video Workflow (Shorts)

### Method 1: Reframe Tool

1. Create 1080x1920 timeline (Shorts timeline)
2. Import clips from horizontal timeline
3. Inspector > Retime and Scaling > Cropping: Crop to fill
4. Use Transform controls to position subject

### Method 2: Smart Reframe (Studio)

1. Color page > Select clip
2. Effects > ResolveFX Transform > Smart Reframe
3. Auto-detects and follows subject
4. Fine-tune with keyframes if needed

### Method 3: Manual Keyframing

1. Edit page > Inspector > Transform
2. Keyframe Position X to follow action
3. Use Smooth curve for fluid motion

---

## Render Queue Workflow

For batch exports:

1. Set up Deliver page presets (Master, Shorts)
2. Add to Render Queue (don't render yet)
3. Switch timeline, set next export
4. Add to Render Queue
5. Render All

Recommended render order:
```
1. Master (1080p horizontal)     -> 05-exports/master/
2. YouTube Shorts (1080x1920)    -> 05-exports/shorts/youtube/
3. Instagram Reels               -> 05-exports/shorts/instagram/
4. TikTok                        -> 05-exports/shorts/tiktok/
```

---

## Project Templates

Save empty project as template:
1. Set all project settings
2. Create timeline presets (Main + Shorts)
3. Add placeholder bins in Media Pool
4. File > Export Project
5. Save to: `03-project/davinci/template.drp`

For new projects:
1. File > Import Project
2. Select template.drp
3. Rename project
4. Link media from 01-raw/
