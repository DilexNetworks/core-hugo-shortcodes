---
title: "Why namespaced shortcodes?"
summary: the 'dx' namespace
build:
  list: never
---

## Why namespaced shortcodes?

All shortcodes in this module are namespaced under `dx/` (for
example: `dx/photo`, `dx/code`).

Hugo does not provide automatic isolation between shortcodes coming
from different themes or modules. If two themes or modules define
a shortcode with the same name (for example `code` or `photo`),
whichever one Hugo resolves first will “win” — often leading to
confusing or hard-to-debug behavior.

Namespacing solves this by:

- **Avoiding collisions** with themes like Blowfish (which already defines `code`)
- **Making ownership explicit**
- **Allowing safe composition** of multiple Hugo modules
- **Future-proofing the API** as the module grows

If you prefer shorter aliases for a specific site, you can create
local wrapper shortcodes that delegate to the `dx/*` versions.
