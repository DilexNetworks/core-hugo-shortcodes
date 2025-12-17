---
title: "dx/compare - Compare shortcode test"
summary: "A quick test page for the compare shortcode (side-by-side + slider)."
---

This page is used to validate the `compare` shortcode end-to-end:

- HTML output renders correctly
- the slider works (JS loads once via `scripts.gohtml`)
- CSS is applied
- common parameters don’t break the build

> Tip: keep `before.jpg` and `after.jpg` in the same page bundle folder as this `index.md` so the examples work with simple relative paths.

## Side-by-side

**Code**

```go-html-template
{{</* dx/compare
  left_src="before.jpg"
  left_alt="Before"
  left_caption="Before"
  right_src="after.jpg"
  right_alt="After"
  right_caption="After"
  width="50:50"
  gap="1rem"
*/>}}
```

**Renders**

{{< dx/compare
  left_src="before.jpg"
  left_alt="Before"
  left_caption="Before"
  right_src="after.jpg"
  right_alt="After"
  right_caption="After"
  width="50:50"
  gap="1rem"
>}}

## Slider (default 50%)

**Code**

```go-html-template
{{</* dx/compare
  mode="slider"
  left_src="before.jpg"
  left_alt="Before"
  right_src="after.jpg"
  right_alt="After"
  slider_pos="50"
  slider_label_left="Before"
  slider_label_right="After"
*/>}}
```

**Renders**

{{< dx/compare
  mode="slider"
  left_src="before.jpg"
  left_alt="Before"
  right_src="after.jpg"
  right_alt="After"
  slider_pos="50"
  slider_label_left="Before"
  slider_label_right="After"
>}}

## Slider (custom start position + credits)

**Code**

```go-html-template
{{</* dx/compare
  mode="slider"
  left_src="before.jpg"
  left_alt="Before"
  left_credit="Before image"
  left_credit_align="left"
  right_src="after.jpg"
  right_alt="After"
  right_credit="After image"
  right_credit_align="right"
  slider_pos="35"
  slider_label_left="Before"
  slider_label_right="After"
*/>}}
```

**Renders**

{{< dx/compare
  mode="slider"
  left_src="before.jpg"
  left_alt="Before"
  left_credit="Before image"
  left_credit_align="left"
  right_src="after.jpg"
  right_alt="After"
  right_credit="After image"
  right_credit_align="right"
  slider_pos="35"
  slider_label_left="Before"
  slider_label_right="After"
>}}

## Notes

- If the slider doesn’t move, check the browser devtools Network tab for `dx-compare.js`.
- If you see errors about `width`, try removing it or using the `NN:NN` format (for example `60:40`).