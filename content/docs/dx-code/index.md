---
title: "dx/code – Code blocks for documentation"
summary: "Display syntax-highlighted code blocks with optional copy button and line numbers."
---

The `dx/code` shortcode provides a consistent, documentation‑friendly way to display code examples.

It wraps Hugo’s built‑in syntax highlighting (Chroma) with a clean visual frame, optional copy‑to‑clipboard support, and a small API designed specifically for writing docs.

## Why use `dx/code`?

- Consistent styling across docs pages
- Optional **copy** button for readers
- Optional **line numbers** (via Chroma)
- Can load examples from files, avoiding Hugo shortcode escaping
- Namespaced (`dx/`) to avoid conflicts with themes like Blowfish

## Usage

### Parameters

- `lang` (optional)  
  Language for syntax highlighting (default: `text`)

- `copy` (optional)  
  `true | false` (default: `true`)  
  Show or hide the copy button

- `linenos` (optional)  
  `true | false` (default: `false`)  
  Enable line numbers

- `title` (optional)  
  Small title shown above the code block

- `file` (optional)  
  Path to a file containing the code to display  
  - First checks page bundle resources
  - Falls back to `readFile` (site‑relative)

## Examples

### Basic usage (inline code)

```go-html-template
{{</* dx/code lang="bash" title="Run the docs site" */>}}
hugo server -D
{{</* /dx/code */>}}
```

{{< dx/code lang="bash" title="Run the docs site" >}}
hugo server -D
{{< /dx/code >}}

### Disable copy button and enable line numbers

```go-html-template
{{</* dx/code lang="go-html-template" copy="false" linenos="true" */>}}
{{</* dx/photo src="test.jpg" caption_pos="below" */>}}Caption{{</* /dx/photo */>}}
{{</* /dx/code */>}}
```

{{< dx/code lang="go-html-template" copy="false" linenos="true" >}}
{{</* dx/photo src="test.jpg" caption_pos="below" */>}}Caption{{</* /dx/photo */>}}
{{< /dx/code >}}

### Recommended: load code from a file

When documenting Hugo shortcodes, loading code from a file avoids the
`{{</* ... */>}}` escape pattern entirely.

Example structure:

```
content/shortcodes/dx-code/
└─ snippets/
   └─ photo-basic.txt
```

Contents of `photo-basic.txt`:

```text
{{</* dx/photo src="test.jpg" caption_pos="below" >}}Caption{{< /dx/photo */>}}
```

Render it with:

```go-html-template
{{</* dx/code file="snippets/photo-basic.txt" lang="go-html-template" title="dx/photo example" */>}}{{</* /dx/code */>}}
```

{{< dx/code file="snippets/photo-basic.txt" lang="go-html-template" title="dx/photo example" >}}{{< /dx/code >}}

## Notes

- Highlight colors are controlled by Hugo’s Chroma configuration
  (`markup.highlight.style` in `hugo.toml`)
- With `noClasses = true`, Chroma emits inline styles and requires no extra CSS
- For light/dark theme switching, set `noClasses = false` and load Chroma CSS themes