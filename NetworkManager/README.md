# Superhero Randomizer

UIKit demo that fetches a random hero from the Akabab SuperHero API and shows their image plus key stats. Built programmatically with Auto Layout so it drops straight into any Xcode project.

## API

- Base: `https://akabab.github.io/superhero-api/api/`
- Endpoint used: `/all.json` (download full list, then pick a random element locally)

## Running the project

1. Open the `NetworkManager.xcodeproj` file in Xcode 15+.
2. Build & run on a simulator or device.
3. Tap **Randomize** to load a new hero.

No extra Info.plist settings or dependencies required—`URLSession` handles the HTTPS requests.

## Features

- Codable models that mirror the API response.
- `NetworkManager` with `Result`-based error handling, including empty response defense.
- `ImageLoader` cache to avoid refetching hero images.
- Scrollable UIKit layout built with `UIStackView`, showing ≥10 attributes spanning powerstats, appearance, biography, work, and connections.
- Button-disabled loading state, alert-driven retries, and SF Symbol placeholder on image failure.
- Subtle fade + scale animation when the hero image swaps to keep the UI lively.

## Demo tips

- Record a 1–2 minute screen capture (QuickTime → New Screen Recording works well).
- Show multiple randomizations so viewers see different stats/images and the animation.
- Briefly toggle Airplane Mode (or disable network) and tap **Randomize** to demonstrate the error alert and retry flow.

