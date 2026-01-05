---
title: "Install"
summary: How to use this module (and contribute)
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

2) Add the module to your site’s `hugo.toml`.  NOTE the path here has `/module` appended:

```toml
[module]
  [[module.imports]]
    path = "github.com/DilexNetworks/core-hugo-shortcodes/module"
```

3) Fetch dependencies:

```bash
hugo mod get -u
hugo mod tidy
```

> ⚠️ **SCSS build requirement (Dart Sass)**
>
> This module compiles SCSS using **Dart Sass** (via Hugo Pipes).
> You must have the `sass` binary available on your system and in your `PATH`.
>
> **macOS (Homebrew):**
> ```bash
> brew install sass/sass/sass
> ```
>
> **Linux:**
> ```bash
> brew install sass/sass/sass
> # or
> sudo snap install dart-sass
> ```
>
> **Windows:**
> ```powershell
> choco install sass
> # or
> scoop install sass
> ```
>
> You can verify Hugo sees the transpiler by running:
> ```bash
> hugo env
> ```

4) Add the optional **DX head shim** (recommended for sites that use the dx CSS/JS bundles):

Create this file in your site:

- `layouts/partials/extend-head.html`

With the following contents:

```go-html-template
{{ if templates.Exists "partials/dx/extend-head.html" }}
  {{ partial "dx/extend-head.html" . }}
{{ end }}
```

> If you already have a theme-provided `extend-head.html`, keep it and add the snippet above to it.


You can now use the shortcodes in your content:

```md
{{</* dx/photo src="images/test.jpg" caption_pos="below" >}}Caption{{< /dx/photo */>}}
```

### Updating the module

Hugo modules are versioned and cached. When a new release of this module is published, existing sites will **not** automatically pick it up.

To update **this module only** to the latest version:

```bash
hugo mod get -u github.com/DilexNetworks/core-hugo-shortcodes/module
hugo mod tidy
```

To update **all** Hugo modules used by your site:

```bash
hugo mod get -u
hugo mod tidy
```

If you prefer strict version pinning, you can lock to a specific release in your `hugo.toml`:

```toml
[module]
  [[module.imports]]
    path = "github.com/DilexNetworks/core-hugo-shortcodes/module"
    version = "v0.2.3"
```

In that case, updating means changing the version string explicitly.

### Option B: Git submodule

If you don’t want to use Hugo modules, you can add this repo as a git submodule:

```bash
git submodule add https://github.com/DilexNetworks/core-hugo-shortcodes.git modules/dx-shortcodes
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
make server
```

This is the easiest way to understand how the shortcodes behave before integrating them into another project.

## Getting Started for Contributors

If you plan to hack on the shortcodes (SCSS/CSS, JS, templates), it helps to run the docs site in a way that:

- binds to all interfaces (so you can hit it from your phone/tablet on the same network), and
- sets `baseURL` correctly for the current machine.

### Use the Makefile target

If you have the repo checked out locally, the easiest way is:

```bash
make server
```

This repo’s `server` target discovers your current LAN IP and runs Hugo like:

```bash
hugo server -D \
  --disableFastRender --ignoreCache \
  --config hugo.toml \
  --bind 0.0.0.0 \
  --baseURL=http://<YOUR-IP>:1313/
```

### One-off baseURL override

If you just want to run locally (without the Makefile), you can override the configured `baseURL` at runtime:

```bash
hugo server -D --baseURL http://localhost:1313/
```

This does **not** change your committed config and keeps GitHub Pages URLs intact.
