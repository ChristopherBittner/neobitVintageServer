# N.E.S. Music Mod - Configuration Guide

## Overview

The N.E.S. Music mod enhances Vintage Story with a dynamic music system that provides random playback based on environmental conditions and physical music cylinders. This guide explains how to configure music tracks, triggers, and random playback behavior.

## Music System Architecture

### 1. Music Track Configuration

Music tracks are defined in `/assets/nesmusic/music/nesmusic.json` and registered via patches in `/assets/nesmusic/patches/game-music-integration.json`.

#### Basic Track Structure

```json
{
    "music": {
        "nesmusic:track_name": {
            "file": "track_file.ogg",
            "volume": 1.0,
            "fadeIn": 2.0,
            "fadeOut": 2.0,
            "loop": true,
            "priority": 0.5,
            "conditions": {
                "timeOfDay": "day",
                "weather": "clear",
                "biome": "temperate"
            }
        }
    }
}
```

#### Configuration Parameters

| Parameter | Type | Description | Range |
|-----------|------|-------------|-------|
| `file` | String | OGG audio file path | Relative to sounds/ directory |
| `volume` | Float | Playback volume | 0.0 - 1.0 |
| `fadeIn` | Float | Fade-in duration (seconds) | 0.0+ |
| `fadeOut` | Float | Fade-out duration (seconds) | 0.0+ |
| `loop` | Boolean | Whether track loops | true/false |
| `priority` | Float | Playback priority | 0.0 - 1.0 (higher = more likely to play) |
| `conditions` | Object | Environmental triggers | See conditions below |

### 2. Environmental Triggers

Music tracks are triggered based on game conditions defined in the `conditions` object:

#### Time-Based Triggers

```json
"conditions": {
    "timeOfDay": "day"     // "day", "night", "dawn", "dusk"
}
```

#### Weather Triggers

```json
"conditions": {
    "weather": "clear"     // "clear", "rain", "storm", "snow"
}
```

#### Biome Triggers

```json
"conditions": {
    "biome": "temperate"   // "temperate", "desert", "arctic", "tropical"
}
```

#### Environment Triggers

```json
"conditions": {
    "environment": "underground",  // "underground", "surface", "cave"
    "depth": "deep"                // "shallow", "medium", "deep"
}
```

#### Source Triggers

```json
"conditions": {
    "source": "cylinder_only"  // "cylinder_only", "ambient", "manual"
}
```

### 3. Random Playback System

#### Priority-Based Selection

The music system uses a priority-based random selection:

1. **Priority Calculation**: Each track's priority (0.0-1.0) determines selection likelihood
2. **Condition Matching**: Only tracks matching current conditions are considered
3. **Random Selection**: Higher priority tracks have better chance of being selected
4. **Fade Transitions**: Smooth transitions between tracks using fadeIn/fadeOut

#### Example Priority System

```json
{
    "nesmusic:rain_symphony": {
        "priority": 0.8,    // High priority for rain music
        "conditions": {
            "weather": "rain"
        }
    },
    "nesmusic:night_melody": {
        "priority": 0.6,    // Medium priority for night
        "conditions": {
            "timeOfDay": "night",
            "weather": "clear"
        }
    },
    "nesmusic:example_track": {
        "priority": 0.5,    // Lower priority for general day music
        "conditions": {
            "timeOfDay": "day",
            "weather": "clear",
            "biome": "temperate"
        }
    }
}
```

### 4. Physical Music Cylinders

#### Regular Music Cylinder

- **Item Code**: `nesmusic:music-cylinder`
- **Crafting**: Requires `crafty` trait
- **Recipe**: 3x1 grid `MWG` (Metal-Wood-Gear)
- **Materials**: 2x Copper plate, 1x Wood plank, 1x Temporal gear
- **Behavior**: Contains random environmental music that plays based on current conditions

#### Exclusive Music Cylinder

- **Item Code**: `nesmusic:exclusive-music-cylinder`
- **Crafting**: Requires `tinkerer` trait
- **Recipe**: 3x2 grid with diamond in center
- **Materials**: 2x Gold plate, 1x Wood plank, 2x Temporal gears, 1x Rough diamond
- **Behavior**: Contains exclusive tracks that only play from physical cylinders

### 5. Adding New Music Tracks

#### Step 1: Add Audio File

Place OGG file in `/assets/nesmusic/sounds/` directory:
- Format: OGG Vorbis
- Sample Rate: 44.1 kHz
- Bitrate: 128-320 kbps
- Channels: Stereo (2 channels)

#### Step 2: Define Track in Music Config

Add to `/assets/nesmusic/music/nesmusic.json`:

```json
{
    "music": {
        "nesmusic:my_new_track": {
            "file": "my_new_track.ogg",
            "volume": 0.9,
            "fadeIn": 2.5,
            "fadeOut": 2.5,
            "loop": true,
            "priority": 0.7,
            "conditions": {
                "timeOfDay": "day",
                "weather": "clear"
            }
        }
    }
}
```

#### Step 3: Register Track via Patch

Add to `/assets/nesmusic/patches/game-music-integration.json`:

```json
{
    "op": "add",
    "path": "/music/nesmusic:my_new_track",
    "value": {
        "file": "nesmusic/my_new_track.ogg",
        "volume": 0.9,
        "fadeIn": 2.5,
        "fadeOut": 2.5,
        "loop": true,
        "priority": 0.7,
        "conditions": {
            "timeOfDay": "day",
            "weather": "clear"
        }
    }
}
```

#### Step 4: Add Language Entry

Add to `/assets/nesmusic/lang/en.json`:

```json
{
    "music-nesmusic:my_new_track": "My New Track"
}
```

### 6. Advanced Configuration Examples

#### Complex Environmental Triggers

```json
{
    "nesmusic:stormy_night": {
        "file": "stormy_night.ogg",
        "volume": 0.8,
        "fadeIn": 3.0,
        "fadeOut": 3.0,
        "loop": true,
        "priority": 0.9,
        "conditions": {
            "timeOfDay": "night",
            "weather": "storm",
            "biome": "temperate"
        }
    }
}
```

#### Underground Exploration Music

```json
{
    "nesmusic:deep_cavern": {
        "file": "deep_cavern.ogg",
        "volume": 0.7,
        "fadeIn": 4.0,
        "fadeOut": 4.0,
        "loop": true,
        "priority": 0.8,
        "conditions": {
            "environment": "underground",
            "depth": "deep"
        }
    }
}
```

#### Exclusive Cylinder Track

```json
{
    "nesmusic:rare_melody": {
        "file": "rare_melody.ogg",
        "volume": 1.0,
        "fadeIn": 1.5,
        "fadeOut": 1.5,
        "loop": false,
        "priority": 1.0,
        "conditions": {
            "source": "cylinder_only"
        }
    }
}
```

### 7. Troubleshooting

#### Music Not Playing

1. Check file path in `file` parameter
2. Verify OGG file is in correct directory
3. Ensure conditions match current game state
4. Check priority value (higher = more likely)

#### Poor Audio Quality

1. Verify OGG encoding settings
2. Check volume levels (0.0-1.0)
3. Adjust fadeIn/fadeOut for smoother transitions

#### Cylinder Not Working

1. Ensure correct item code in recipe
2. Verify required traits are present
3. Check cylinder placement and activation

### 8. File Structure Reference

```
nesmusic/
├── modinfo.json                           # Mod metadata
├── README.md                             # Basic documentation
└── assets/
    └── nesmusic/
        ├── music/
        │   └── nesmusic.json             # Music track definitions
        ├── patches/
        │   └── game-music-integration.json  # Track registration patches
        ├── itemtypes/
        │   └── exclusive-music-cylinder.json  # Cylinder item definitions
        ├── recipes/
        │   └── grid/
        │       ├── music-cylinder.json      # Regular cylinder recipe
        │       └── exclusive-music-cylinder.json  # Exclusive cylinder recipe
        ├── lang/
        │   └── en.json                   # Language/localization
        └── sounds/
            ├── example_track.ogg         # Audio files
            ├── cavern_ambient.ogg
            ├── night_melody.ogg
            ├── rain_symphony.ogg
            └── exclusive_cylinder_track.ogg
```

This configuration system allows for highly customizable music experiences that respond dynamically to game conditions while maintaining smooth transitions and appropriate audio levels.


