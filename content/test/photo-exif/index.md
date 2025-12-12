---
title: "Photo EXIF Test"
---

## No overrides (should read EXIF)
{{< photo src="test.jpg" >}}
Test it out!
{{< /photo >}}

## With overrides (should prefer params)
{{< photo src="test.jpg" camera="My Camera" iso="ISO 800" >}}
Test it out! *With overrides (should prefer params)*
{{< /photo >}}
