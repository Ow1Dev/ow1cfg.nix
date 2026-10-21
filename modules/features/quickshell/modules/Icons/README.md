# Panel icons

SVG assets use a 24-unit viewBox and white strokes. `Icon.qml` applies the requested
color, keeping hover and status colors in the caller. The battery uses a cropped
viewBox so its outline fills a 24 × 16 slot.

From another module:

```qml
import "../Icons" as Icons

Icons.Icon {
    name: "search" // SVG filename without the extension
    width: 18
    height: 18
    color: Nord.accent
}
```

Add a new SVG alongside these files to use it by name. `NetworkBars.qml` draws the network signal directly as square-edged rectangles
with pixel-sized strokes and gaps. Set `strength` (0–4), `color`, `inactiveColor`,
and `renderScale` to reuse it. The battery fill stays in `Battery.qml`
so it follows the live percentage.

`BellIcon` and `BoltIcon` use `VectorIcon` to draw paths directly with Qt Quick
Shapes, avoiding raster scaling. Set `color` for strokes and `fillColor` for fills.
The charging bolt is drawn inside the battery outline.
