# Store screenshots

Renders the real app screens with demo moments at the store sizes, inside a phone or tablet
frame with a caption, in English, German and Arabic. No phone or simulator is needed: it is a
`flutter test` that pumps the app with a fake memory repository and saves PNGs.

```bash
tool/store_screenshots/run.sh                                   # 6 sizes × 3 languages × 5 scenes
STORE_SIZES=ios-6.9 STORE_LANGS=en STORE_SCENES=wall tool/store_screenshots/run.sh
```

Output: `store_listing_assets/store_screenshots/<size>/<lang>/NN-scene.png` (gitignored, rebuild it).

| Size | Pixels | Store slot |
|---|---|---|
| `play-phone` | 1080×1920 | Google Play phone |
| `play-tablet-7` | 1200×1920 | Google Play 7″ tablet |
| `play-tablet-10` | 1600×2560 | Google Play 10″ tablet |
| `ios-6.9` | 1320×2868 | App Store iPhone 6.9″ |
| `ios-6.5` | 1242×2688 | App Store iPhone 6.5″ |
| `ios-ipad-13` | 2064×2752 | App Store iPad 13″ |

Scenes, in listing order: `wall`, `memory` (a memory's hero), `story` (story, people and threads),
`timeline`, `add` (saving a moment with three photos).

## How it works

- `fixtures.dart` holds the nine demo moments (titles and stories per language), their threads,
  people and the captions. The photos are in `store_listing_assets/store_moments/`, generated with
  Figma AI; they are served to the app as `assets/store_moments/…` by a test asset bundle and are
  not shipped in the app.
- `fonts.dart` loads Avenir (the theme font) and SF Arabic from macOS, as an iPhone shows them,
  plus Material Icons from the Flutter SDK. So this runs on a Mac only.
- `store_frame.dart` draws the caption, device frame and status bar (9:41); the app is laid out at
  the device's real logical size and scaled into the frame.

The map view is not among the scenes: its OpenFreeMap vector tiles do not render under
`flutter test` (the map stays grey).
