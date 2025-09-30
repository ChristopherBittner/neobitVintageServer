# N.E.S. Music Mod

A comprehensive music enhancement mod for Vintage Story that adds dynamic music playback and physical music cylinders.

## Features

### Random Music Playback
- **Environmental Music**: Music tracks that play based on game conditions
  - Day time music for clear weather
  - Night melodies for peaceful evenings
  - Cavern ambient sounds for underground exploration
  - Rain symphonies for stormy weather

### Physical Music Cylinders
- **Music Cylinder**: Craftable cylinder containing random environmental music
  - Requires: `crafty` trait
  - Materials: Copper plate, wood plank, temporal gear
  - Plays music based on current environmental conditions

- **Exclusive Music Cylinder**: Rare cylinder with unique tracks
  - Requires: `tinkerer` trait  
  - Materials: Gold plate, wood plank, temporal gears, rough diamond
  - Contains exclusive tracks that only play from this physical cylinder

## Music Tracks

### Environmental Tracks (Random Playback)
1. **Example Track** - Daytime clear weather music
2. **Cavern Ambient** - Deep underground exploration music
3. **Night Melody** - Peaceful night time music
4. **Rain Symphony** - Stormy weather music

### Exclusive Tracks (Cylinder Only)
1. **Exclusive Cylinder Track** - Unique track only available through physical cylinders

## Installation

1. Place the mod folder in your Vintage Story mods directory
2. Ensure you have the required traits to craft music cylinders
3. Music will automatically integrate with the game's existing music system

## Usage

### Crafting Music Cylinders
- **Music Cylinder**: 3x1 grid pattern `MWG` (Metal-Wood-Gear)
- **Exclusive Music Cylinder**: 3x2 grid pattern with diamond in center

### Music Playback
- Environmental music plays automatically based on conditions
- Physical cylinders can be placed and activated manually
- Music integrates seamlessly with existing game music

## Technical Details

- **Mod ID**: `nesmusic`
- **Dependencies**: Vintage Story 1.21.1+
- **Client Required**: Yes
- **Server Required**: No

## File Structure

```
nesmusic/
├── modinfo.json
├── modicon.png
├── README.md
└── assets/
    └── nesmusic/
        ├── music/
        │   └── nesmusic.json
        ├── itemtypes/
        │   ├── music-cylinder.json
        │   └── exclusive-music-cylinder.json
        ├── recipes/
        │   └── grid/
        │       ├── music-cylinder.json
        │       └── exclusive-music-cylinder.json
        ├── patches/
        │   └── game-music-integration.json
        ├── lang/
        │   └── en.json
        └── sounds/
            ├── example_track.ogg
            ├── cavern_ambient.ogg
            ├── night_melody.ogg
            ├── rain_symphony.ogg
            └── exclusive_cylinder_track.ogg
```

## Adding Your Own Music

1. Place OGG audio files in the `sounds/` directory
2. Update `music/nesmusic.json` with new track definitions
3. Update `patches/game-music-integration.json` to register new tracks
4. Add language entries in `lang/en.json` for track names

## Music File Specifications

- **Format**: OGG Vorbis
- **Sample Rate**: 44.1 kHz
- **Bitrate**: 128-320 kbps
- **Channels**: Stereo (2 channels)
- **Duration**: 2-5 minutes for looping tracks, 1-3 minutes for exclusive tracks






