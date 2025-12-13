---
title: "photo - Photo Display with captions and EXIF"
---

The photo shortcode was built to display images with captions and EXIF data.  Wrapping this in a *bbox*
shortcode is a nice way to make a callout box around the image.

## Usage

- `src` (required): image URL or Page resource path
- `alt` (optional): alt text
- `caption` (optional): text
- `caption_pos` (optional): `above|below|left|right` (default: `below`)
- `overlay` (optional): `true|false` — if true, caption+button overlay bottom-right of image
- `info` (optional): true|false — show info button to toggle camera details
- `camera`, `lens`, `shutter`, `aperture`, `iso` (optional): details for the info panel
- `width`, `height` (optional): CSS sizes (e.g., `100%`, `520px`)
- `class` (optional): extra classes for wrapper

### Examples

This example will display an image with a caption below it.  It will also
put a small info icon in the bottom right corner of the image that, when
clicked, will pop up the EXIF data for the image (`info=true`).

```
{{</* photo 
    src="images/HarbourFog.jpg"
    alt="Fog Rolling in at St. John's Harbour"
    caption_pos="below"
    width="100%" 
    overlay="true"
    info="true">}}
This image was post processed with Nik Tools Color Efex 6. 
{{< /photo */>}}
```

This example shows how to override the EXIF data that is pulled from the
image.  This can come in handy when EXIF data is incorrect, like maybe you
were using a lens on an adapter so the camera could not identify it, or just
plain missing like in the case where the image came from a film camera.

For aperture, you need to add the `ƒ` manually (if you want it)
```
{{</* photo 
    src="images/HarbourFog.jpg"
    alt="Fog Rolling in at St. John's Harbour"
    caption_pos="below"
    camera="Leica R8"
    lens="Leica R Summicron 1:2/90mm"
    aperture="ƒ/?"
    width="100%" 
    overlay="true"
    info="true">}}
This image was post processed with Nik Tools Color Efex 6. 
{{< /photo */>}}
```

## Examples
### No overrides (should read EXIF)
{{< photo src="test.jpg" >}}
Test it out!
{{< /photo >}}

### With EXIF overrides (should prefer params)
{{< photo src="test.jpg" camera="My Camera" 
    iso="ISO 800" 
    caption_pos="left" >}}
Test it out! This is a fairly long caption that should be on the
left side of the image.  If the web browser is less than 640px - like
on a mobile phone - the caption will be below the image.
*With overrides (should prefer params)*
{{< /photo >}}
