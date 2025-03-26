# App styling guide

This app provides an easy way to apply shared styles to widgets, to build a beautiful UI with simple and consistent design.

In general, you can apply styles to widgets using the `style` property:

```dart
Text(
    "Hello world!",
    style: TextStyle(... <style settings here> ...), // creates new style
)
```

To leverage shared app styles, avoid creating new styles (like the example above), but access the app styles database, like the example below:

```dart
Text(
    "Hello world!",
    style: context.styles.accent.txt.special, // accesses shared app styles
)
```

The styling system uses this syntax:

```dart
context.styles.<appStyle>.<widgetType>.<extra1>.<extra2>...
```

Every element composing the syntax is described below.

**1. `context.styles`**
To begin, just write `context.styles` to access app styles from widget code.

**2. `<appStyle>`**
Then choose the desired app style, that define the background color of elements:
- `basic`: for normal elements
- `accent`: for important elements, to be highlighted
- `background`: for less important elements

**3. `<widgetType>`**
Then choose the type of widget you are targeting:
- `txt`: texts and labels
- `btn`: buttons
- `box`: containers

**4. `<extras>` for texts**
Change the evidence of texts, using these extras:
- `normal`: for normal text
- `special`: for important text, to be highlighted
- `faded`: for less important text, not to be so visible

Other text extras:
- `bold`: for bold font
- `size(n)`: for bigger texts (1: small, 2: medium, 3: large)


**5. `<extras>` for containers only**
If you wish, add fancy effects:
- `rounded`: round box borders
- `shadow`: add shadow to the box, for 3D effect

**6. `<extras>` for containers and buttons**
- `outline`: add border to the box/button, useful with background style
- `wide`: make box/button wide, to match parent, useful in forms

**Examples**

```dart
// styles for texts
context.styles.basic.txt.normal // default text, on normal element
context.styles.basic.txt.special.bold.size(3) // ultra-visible text
context.styles.accent.txt.special // evident text, on evident element
context.styles.accent.txt.faded // less evident text, on evident element

// styles for containers
context.styles.accent.box.rounded
context.styles.background.box.outlined

// styles for buttons
context.styles.basic.btn // default button
context.styles.accent.btn.wide // visible and wide button
context.styles.background.btn.outline // button with background color
```

See [`lib/dev/styles.dart`](lib/dev/styles.dart) for a complete working example.
