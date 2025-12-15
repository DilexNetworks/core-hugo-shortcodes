---
title: "Install"
summary: how to use this module
build:
  list: never
---

## Install

This repo serves two purposes:

- a **Hugo module** that provides reusable, namespaced shortcodes, and
- a **self-documenting demo site** you can run locally to explore examples.

### Option A: Hugo Module (recommended)

1) Initialize Hugo modules in your site (one-time setup):

```bash
hugo mod init example.com/your-site
```

2) Add the module to your site’s `hugo.toml`:

```toml
[module]
  [[module.imports]]
    path = "github.com/DilexNetworks/dilex-hugo-shortcodes"
```

3) Fetch dependencies:

```bash
hugo mod get -u
hugo mod tidy
```

You can now use the shortcodes in your content:

```md
{{</* dx/photo src="images/test.jpg" caption_pos="below" >}}Caption{{< /dx/photo */>}}
```

### Option B: Git submodule

If you don’t want to use Hugo modules, you can add this repo as a git submodule:

```bash
git submodule add https://github.com/DilexNetworks/dilex-hugo-shortcodes.git modules/dx-shortcodes
```

From there you can either:

- copy the required `layouts/` and `assets/` into your site, or
- configure Hugo module mounts manually (more advanced).

### Option C: Copy/paste (quick but manual)

If you only need a single shortcode (for example `dx/photo`):

- copy `layouts/shortcodes/dx/photo.gohtml`
- copy any required helpers under `layouts/partials/dx/`
- copy required assets (CSS/JS referenced by the shortcode)

This works, but you’ll need to manually track updates.

### Running the docs site locally

This repository is itself a runnable Hugo site. To explore the examples:

```bash
hugo server -D
```

This is the easiest way to understand how the shortcodes behave before integrating them into another project.