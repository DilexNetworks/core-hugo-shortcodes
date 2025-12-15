---
title: "Design notes"
summary: some of the design decisions that were made while building this module
build:
  list: never
---

## Design notes

A few decisions in this module are intentional (and make it easier to reuse across wildly different Hugo sites).

### Namespaced shortcodes

All public shortcodes live under `dx/` (for example: `dx/photo`).

Hugo shortcodes aren’t isolated across themes/modules. Namespacing makes behavior predictable and avoids collisions (Blowfish already defines `code`, for example).

### BEM-style CSS classes

You’ll see classes like:

- `photo` (the “block”)
- `photo__img` / `photo__overlaybar` (elements inside the block)
- `photo--overlay` / `photo--side` (modifiers)

This keeps styles portable and reduces the chance of class collisions with whatever theme you’re using.

### Minimal assumptions about the host theme

This module tries not to rely on theme-specific typography, utilities, or JS frameworks.
If something needs JS (like the photo info toggle), it ships its own small JS file.

### Conditional JS loading

Some shortcodes register what they need via `.Page.Scratch` so pages only load the scripts they actually use.

That keeps the docs site (and consumer sites) lighter and makes it easier to grow the module without turning it into a big global bundle.

### Mobile-first fixes live in CSS

If a layout looks good on desktop but fails on phone (like side captions), the preference is to solve it with CSS breakpoints rather than UA sniffing or JS “detect mobile” logic.

### Versioning + stability

The goal is for the shortcodes to be “library stable”:

- avoid breaking parameter changes
- add new behavior behind new params
- keep docs/examples runnable as a basic regression check