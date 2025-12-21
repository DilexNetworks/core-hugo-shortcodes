---
title: "Theme overrides"
summary: "Override dx/* colours and dx/code syntax highlighting using CSS variables — no forks required."
---

This module exposes its colours as CSS custom properties (variables) using the `--dx-*` prefix. Most shortcodes share a common palette (surface + status tones), so you can theme **all** dx/* components consistently without forking or copying the module’s CSS.

## The rule: define your overrides after the dx stylesheet

```go-html-template
{{/* dx shortcode styles (module bundle) */}}
{{- $dx := resources.Get "dx/scss/dx.scss" | css.Sass | minify | fingerprint -}}
<link rel="stylesheet" href="{{ $dx.RelPermalink }}" integrity="{{ $dx.Data.Integrity }}">

{{/* your site overrides (must come after dx) */}}
{{- with resources.Get "css/dx-overrides.css" -}}
  {{- $ov := . | minify | fingerprint -}}
  <link rel="stylesheet" href="{{ $ov.RelPermalink }}" integrity="{{ $ov.Data.Integrity }}">
{{- end -}}
```

If your theme doesn’t use `extend-head.html`, the same rule still applies: include your override CSS **after** the dx stylesheet.
This applies to both colour palette tokens and `dx/code` syntax token overrides.
## Customizing syntax highlighting

`dx/code` uses Hugo’s built-in syntax highlighter (Chroma). The dx stylesheet maps common Chroma token classes to CSS variables so you can theme code blocks without editing module CSS.

### 1) Make sure Hugo uses classes (not inline styles)

In your site config, set:

```toml
[markup.highlight]
  noClasses = false
```

If `noClasses` is `true`, Hugo will emit inline styles and CSS-variable overrides won’t apply cleanly.

### 2) Override dx/code token colours

Add overrides **after** the dx bundle (same rule as colours). For example:

```css
:root {
  --dx-code-token-comment: #6a737d;
  --dx-code-token-keyword: #9b59b6;
  --dx-code-token-string:  #27ae60;
  --dx-code-token-function:#2980b9;
}
```

### 3) Dark-mode token overrides

Scope overrides to your theme’s dark-mode selector (dx listens for several common ones):

```css
:where(html.dark, [data-theme="dark"]) {
  --dx-code-token-comment: #94a3b8;
  --dx-code-token-keyword: #d6acff;
  --dx-code-token-string:  #9ece6a;
}
```

Tip: if a theme uses a different dark-mode signal, target whatever changes on the `<html>` element when you toggle the theme.


## Theme compatibility

Different Hugo themes signal dark mode in different ways. The dx stylesheet listens for several common patterns so it “just works” across most themes.

Here are the most common ones you’ll run into:

- **Blowfish / Tailwind-style themes:** add a `.dark` class to the `<html>` element (e.g. `html.dark`).
- **Data-attribute themes:** set `data-theme="dark"` or `data-scheme="dark"` on `<html>`.
- **Bootstrap-style themes:** set `data-bs-theme="dark"` on `<html>`.

If your theme uses a different mechanism, you can still override dx tokens by targeting whatever selector your theme applies in dark mode (the important part is that your overrides run *after* the dx stylesheet).

Tip: use your browser devtools to inspect the `<html>` element while toggling the theme — whatever class/attribute changes there is the best selector to use.

## Global overrides

To change colours across the entire site, define overrides on `:root` in a stylesheet that loads after the dx stylesheet:

```css
:root {
  /* Surface used by neutral components (bgbox, cards, etc.) */
  --dx-surface: #f6f7fb;
  --dx-surface-border: #d6dbe6;

  /* Status tones used by tone="info|warn|danger|success" */
  --dx-info-bg: #e8f0ff;
  --dx-info-border: #7aa2ff;
}
```

## Scoped overrides (only part of the site)

CSS variables cascade, so you can scope overrides to a specific container:

```css
.docs {
  --dx-surface: #f8fafc;
}
```

Then wrap the relevant content:

```html
<div class="docs">
  <!-- shortcodes content -->
</div>
```

Only bgboxes inside that container will use the overridden values.

## Dark mode overrides

The module normalizes dark mode across themes by looking for common dark-mode signals (for example `html.dark` in Blowfish, or `[data-theme="dark"]` in other setups). To override only in dark mode, target one of those signals:

```css
:where(html.dark, [data-theme="dark"]) {
  --dx-surface: #0f172a;
  --dx-surface-border: #1f2a3a;
}
```

## Where to find the variables

Default values live in the module’s token layer (SCSS), primarily `assets/dx/scss/_tokens.scss`. Component-specific rules live alongside it (for example `_bgbox.scss`). In most cases you’ll get the best results by overriding the shared palette tokens (`--dx-surface`, `--dx-info-bg`, etc.) rather than per-component internals.
