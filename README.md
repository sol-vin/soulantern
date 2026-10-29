# Soulantern

A fast-paced retro 3D platformer FPS where your lantern is your mobility, weapon, and lifeline. Built with **Godot Engine 4.8** and high-performance **Crystal** via [Lapis](https://github.com/sol-vin/lapis).

## Features

- **Crystal Movement Engine**: Custom GoldSrc / Quake-style movement physics (air acceleration, strafe jumping, ramp sliding, autohop) natively compiled in Crystal.
- **Lantern Mechanics**:
  - **Left Click**: Rocket-jump projectile that explodes on surfaces to fling the player into high-altitude arcs.
  - **Right Click**: Directional air dash with momentum preservation and blue floor fire trails.
- **Retro Aesthetic**: Palette-swapping screen-space shader pipelines, retro CRT aesthetics, and TrenchBroom / FuncGodot level geometry.
- **Zero-GDScript Core**: All gameplay logic, player physics, pickups, weapons, triggers, and menus are compiled into native Crystal shared libraries.

## Building and Running

### Prerequisites

- [Crystal Compiler](https://crystal-lang.org/) (1.20+)
- [Godot Engine](https://godotengine.org/) (4.8-beta1)
- [Lapis CLI](https://github.com/sol-vin/lapis)

### Commands

```bash
# Install shards dependencies
shards install

# Compile the native game shared library
make game-dll

# Compile release-optimized shared library
make game-dll RELEASE=1

# Run the project with Godot
make run

# Package a standalone playable distribution
make package-game
```

## Continuous Integration & Releases

Automated multi-platform CI and releases are powered by GitHub Actions:
- **CI**: Runs specification verification across Linux, Windows, and macOS on every commit and PR.
- **Releases**: Packages standalone executables and libraries attached directly to GitHub Releases upon tag creation (`v*`).

## License

MIT License.