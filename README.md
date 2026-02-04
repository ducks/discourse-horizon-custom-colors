# discourse-theme-custom-colors

A Discourse theme component that lets users customize their interface colors by
pasting a string of hex values, similar to Slack's theme feature.

## Features

- User-specific colors (each user has their own)
- Simple hex string input (e.g., `#1a1a2e #16213e #0f3460 #e94560 #ffffff #ffd700`)
- Live preview swatches
- Colors apply immediately and persist across sessions

## Color Order

1. Primary (text)
2. Secondary (background)
3. Tertiary (accents, links)
4. Header background
5. Header text
6. Highlight

## Installation

1. Go to Admin > Customize > Themes
2. Click "Install" and enter the GitHub URL
3. Add the component to your active theme(s)

## Required Setup

For user custom fields to work, add `custom_color_string` to the site setting:

1. Go to Admin > Settings
2. Search for `public user custom fields`
3. Add `custom_color_string` to the list

## Usage

1. Users go to Preferences > Interface
2. Find "Custom Colors" section
3. Paste hex colors separated by spaces
4. Click Save

## Example Color Strings

Cyberpunk:
```
#0d0d0d #1a1a2e #e94560 #0f3460 #ffffff #ffd700
```

Ocean:
```
#1a1a2e #16213e #0f3460 #e94560 #ffffff #00d9ff
```

Forest:
```
#1b2d1b #2d4a2d #4a7c4a #8fbc8f #ffffff #ffd700
```
