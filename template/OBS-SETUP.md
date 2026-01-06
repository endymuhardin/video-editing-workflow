# OBS Multi-Source Recording Setup

**Platform:** MacBook Pro M1 (Apple Silicon)

## Why OBS over QuickTime

- Records multiple sources as separate tracks (easier post-editing)
- Can record screen + camera simultaneously in one file
- Scene switching during recording
- Better codec control (ProRes, H.265)

## Sources Setup

### 1. Screen Capture
```
Source Type: macOS Screen Capture
Name: Screen
Settings:
  - Display: [Your main monitor]
  - Show Cursor: Yes
  - Window capture for specific app (optional)
```

### 2. Camera (Nikon ZFC + CamLink)
```
Source Type: Video Capture Device
Name: Camera-ZFC
Settings:
  - Device: Cam Link 4K
  - Resolution: 1920x1080
  - FPS: 30 (match your camera output)
  - Color Format: Default
  - Buffering: Disable (reduces latency)
```

### 3. Audio Sources

#### Hollyland Lark M2 Setup

```
1. Connect Lark M2 receiver via USB-C to MacBook

2. System Preferences > Sound > Input
   Select: "Hollyland Lark M2"

3. Lark M2 Receiver Settings:
   Gain:           Medium (adjust to avoid clipping)
   Noise Reduction: On (if needed)
   Low-Cut Filter:  On (reduces rumble)
```

#### OBS Audio Configuration

```
Source Type: Audio Input Capture
Name: Mic-LarkM2
Settings:
  Device: Hollyland Lark M2

Source Type: Audio Output Capture
Name: System-Audio
Settings:
  Device: [For capturing system sounds if needed]
```

#### Audio Levels
```
Target peak level:     -12dB to -6dB
OBS Audio Mixer:       Watch for yellow, avoid red
Lark M2 receiver gain: Adjust if clipping
```

## Scene Configuration

Create these scenes for quick switching during recording:

### Scene 1: Talking Head (Full Camera)
```
- Camera-ZFC (full screen)
- Mic-Main (audio)
```

### Scene 2: Screen + Camera Overlay
```
- Screen (full screen, bottom layer)
- Camera-ZFC (corner overlay, top layer)
  Position: Bottom-right
  Size: 320x180 or 25% of screen
- Mic-Main (audio)
```

### Scene 3: Screen Only
```
- Screen (full screen)
- Mic-Main (audio)
```

## Recording Settings (M1 Optimized)

### Output Tab
```
Output Mode: Advanced
Recording:
  Type: Custom Output (FFmpeg)
  Container: mov
  Video Encoder: Apple ProRes (prores_ks)
    - Profile: ProRes 422 LT (good balance, ~30GB/hour)
  Audio Encoder: PCM (uncompressed)
```

**Recommended for M1: Hardware H.265 (smaller files, fast encoding)**
```
Output Mode: Advanced
Recording:
  Type: Standard
  Recording Format: mov
  Encoder: Apple VT H265 Hardware Encoder
  Bitrate: 50000 Kbps (high quality)
  Keyframe Interval: 2s
  Profile: Main

Audio:
  Audio Bitrate: 320 Kbps
  Audio Encoder: CoreAudio AAC
```

M1 hardware encoder benchmarks:
- H.265 @ 50Mbps: ~8GB/hour, minimal CPU usage
- ProRes 422 LT: ~30GB/hour, best for color grading
- ProRes 422: ~50GB/hour, professional quality

### Video Tab
```
Base Resolution: 1920x1080
Output Resolution: 1920x1080
FPS: 30
Downscale Filter: Lanczos (if scaling)
```

### M1 Performance Settings
```
Settings > Advanced:
  Process Priority: Normal
  Renderer: Metal (native M1)
  Color Format: NV12
  Color Space: Rec. 709
  Color Range: Partial
```

## Separate Track Recording (Advanced)

To record camera and screen as separate files for maximum flexibility:

### Method 1: Source Record Plugin
1. Install "Source Record" plugin
2. Add filter to each source
3. Each source records to its own file

### Method 2: Multiple Audio Tracks
```
Settings > Output > Recording:
  Audio Track: 1, 2, 3, 4, 5, 6 (enable multiple)

Then assign each audio source to different tracks:
  - Track 1: Mic-Main
  - Track 2: System-Audio
  - Track 3: Camera audio (if any)

In DaVinci, you can select which track to use.
```

## Hotkeys Setup

```
Settings > Hotkeys:

Switch to Scene "Talking Head":     F1
Switch to Scene "Screen+Camera":    F2
Switch to Scene "Screen Only":      F3
Start Recording:                    F9
Stop Recording:                     F10
```

## Pre-Recording Checklist

- [ ] Camera connected and recognized
- [ ] CamLink showing video feed
- [ ] Correct scene selected
- [ ] Audio levels visible (-12dB to -6dB peak)
- [ ] Recording path set to 01-raw/ folder
- [ ] Sufficient disk space

## CamLink Optimization (M1 Mac)

If experiencing lag or frame drops:

1. Set CamLink to "Deactivate when not showing"
2. Disable preview when not needed
3. Use Thunderbolt/USB-C port directly (not hub)
4. Set Nikon ZFC output to 1080p (not 4K) for stability

### M1 USB Considerations
```
MacBook Pro M1 has 2 Thunderbolt/USB4 ports.
Use a powered USB-C hub for multiple devices:

Port 1 (direct): CamLink 4K (priority - needs bandwidth)
Port 2 (hub):    External SSD, other peripherals

Recommended hubs: CalDigit TS3+, OWC Thunderbolt Hub
```

### CamLink Settings for M1
```
Video Capture Device settings:
  Device: Cam Link 4K
  Preset: High (or Custom)
  Resolution: 1920x1080
  FPS: 30
  Video Format: YUY2 (or MJPEG if YUY2 has issues)
  Color Space: Default
  Buffering: Disable
  Use Preset: Unchecked (for manual control)
```

### Nikon ZFC HDMI Output Settings
```
Camera Menu > Setup > HDMI:
  Output resolution: 1080p
  Output range: Auto

Movie Recording Menu:
  Frame size/rate: 1920x1080 30p

During recording:
  Info display: Off (clean HDMI output)
```

## Output File Location

Set recording path to project folder:
```
Settings > Output > Recording:
  Recording Path: /path/to/project/01-raw/screen/

Use %CCYY-%MM-%DD_%hh-%mm-%ss format for auto-naming
```
