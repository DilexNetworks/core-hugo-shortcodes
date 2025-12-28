# Dilex Hugo Shortcodes (`dilex-hugo-shortcodes`)

Reusable, theme‑friendly Hugo shortcodes designed to make documentation and content‑heavy sites easier to build and maintain.

**Latest release:** `v{{ .Site.Data.version.tag }}` — {{ .Site.Data.version.date }}  
📖 **Documentation:** https://dilexnetworks.github.io/dilex-hugo-shortcodes/

[![Release](https://img.shields.io/github/v/release/DilexNetworks/dilex-hugo-shortcodes?display_name=tag&sort=semver)](https://github.com/DilexNetworks/dilex-hugo-shortcodes/releases/latest)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://dilexnetworks.github.io/dilex-hugo-shortcodes/)

---

## What is this?

`dilex-hugo-shortcodes` is a curated collection of production‑ready Hugo shortcodes with a strong focus on:

- **Clean, composable markup**
- **Light / dark mode compatibility**
- **Minimal theme assumptions**
- **Easy customization via CSS variables**
- **Real‑world documentation use cases**

The module ships with its **own documentation site**, built and published automatically on each release, so users always see docs that match the current version.

---

## Typical use cases

- Technical documentation sites
- Project landing pages
- Blogs with rich media or callouts
- Hugo sites that need reusable UI patterns without adopting a full theme

The shortcodes are namespaced (`dx/*`) to avoid collisions and are designed to work across popular Hugo themes (including Blowfish) with minimal setup.

---

## Getting started (local development)

```bash
git clone https://github.com/DilexNetworks/dilex-hugo-shortcodes.git
cd dilex-hugo-shortcodes
hugo server -D
```

This runs the built‑in documentation site locally.

---

## Available shortcodes

- **`dx/photo`** — Image display with captions, layout options, and EXIF support
- **`dx/bgbox`** — Semantic background callout boxes (info, warn, success, etc.)
- **`dx/code`** — Code blocks with copy button, titles, and line numbers
- **`dx/compare`** — Before / after image comparison slider
- **`dx/pullquote`** — Styled pull quotes with multiple visual variants
- **`dx/version`** — Displays the current release version and date

See the full documentation for usage examples and configuration options:
👉 https://dilexnetworks.github.io/dilex-hugo-shortcodes/

---

## Design philosophy

This project treats shortcodes like **small, reusable components**, not theme features.

The goal is that a consuming site should:
- Import the module
- Use the shortcodes
- Customize styles if desired

…without needing to understand the internal structure of the module.

---

## License

MIT