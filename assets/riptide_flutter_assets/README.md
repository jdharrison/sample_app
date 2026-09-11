# Riptide Flutter Asset Pack

A starter visual system extracted and reconstructed from the Riptide exotic-fish mockup.

## Included

- Brand logo mark + horizontal logo in light/dark variants
- 10 custom Lucide-inspired SVG icons
- Wave + bubble decorative SVGs
- Cropped image assets from the supplied mockup
- Flutter color/theme tokens
- Asset constants
- `pubspec.yaml` asset snippet

## Design system

Primary UI should remain blue-based.

- Deep Ocean `#082B49` — dominant navigation, hero surfaces, footer
- Ocean `#0C4F78` — secondary blue surface
- Aqua `#22B8F0` — primary interactive accent
- Reef Teal `#10B8A7` — sparing status/accent use
- Coral `#FF7A2D` — rare highlight only
- Sea Mist `#EAF5FA` — subtle surface tint only
- Foam `#F7FBFD` — page background

Sea Mist and light neutrals should support spacing and contrast, not dominate the visual identity.

## Flutter usage

Copy `assets/riptide` into your Flutter project and merge `pubspec.assets.yaml` into your real `pubspec.yaml`.

For SVGs, add `flutter_svg`.

Example:

```dart
SvgPicture.asset(RiptideAssets.logoDark);
```

Then:

```dart
MaterialApp(
  theme: buildRiptideTheme(),
  home: const HomePage(),
);
```

## Notes

The raster image crops come from the supplied concept board and are best treated as prototype/demo assets.
For production, replace them with separately licensed source photography or generated originals at final aspect ratios.
