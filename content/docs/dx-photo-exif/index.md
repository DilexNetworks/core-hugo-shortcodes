---
title: "dx/photo - Photo Display with Captions and EXIF Data"
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

```go-html-template
{{</* dx/photo 
    src="images/HarbourFog.jpg"
    alt="Fog Rolling in at St. John's Harbour"
    caption_pos="below"
    width="100%" 
    overlay="true"
    info="true">}}
This image was post processed with Nik Tools Color Efex 6. 
{{< /dx/photo */>}}
```

This example shows how to override the EXIF data that is pulled from the
image.  This can come in handy when EXIF data is incorrect, like maybe you
were using a lens on an adapter so the camera could not identify it, or just
plain missing like in the case where the image came from a film camera.

For aperture, you need to add the `ƒ` manually (if you want it)
```go-html-template
{{</* dx/photo 
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
{{< /dx/photo */>}}
```

## Examples
### Getting EXIF from image

```go-html-template
{{</* dx/photo src="test.jpg" >}}
Test it out!
{{< /dx/photo */>}}
```
{{< dx/photo src="test.jpg" >}}
Test it out!
{{< /dx/photo >}}

### Overriding EXIF data from image 

```go-html-template
{{</* dx/photo src="test.jpg" camera="My Camera"
iso="ISO 800"
caption_pos="left" >}}
...long caption...
{{< /dx/photo */>}}
```

{{< dx/photo src="test.jpg" camera="My Camera" 
    iso="ISO 800" 
    caption_pos="left" >}}
Test it out! This is a fairly long caption that should be on the
left side of the image.  If the web browser is less than 640px - like
on a mobile phone - the caption will be below the image.

In this example, we are overriding the EXIF data on the
image so that the camera type will show up as **My Camera**, ISO is **800**, etc.  This can be useful if the EXIF data is wrong, you want to hide something for some reason, or maybe you are using an App on a mobile phone and you want the name of the app to show up as opposed to the type of phone. 
{{< /dx/photo >}}
