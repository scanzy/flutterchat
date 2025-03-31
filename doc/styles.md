# App styling guide

This app provides an easy way to apply shared styles to widgets, to build a beautiful UI with simple and consistent design.


### First look

In general, you can apply styles to widgets using the `style` property:

```dart
Text(
    "Hello world!",
    style: TextStyle(... <style settings here> ...), // creates new style
)

ElevatedButton(
    onPressed: ..., // button action
    style: ButtonStyle(... <style settings here> ...), // creates new style
    child: ..., // button content
)

// container uses "decoration" property
Container(
    decoration: BoxDecoration(... <style settings here> ...), // creates new style
    child: ..., // widget inside container
)
```

To leverage shared app styles, avoid creating new styles (like the example above), but access the app styles database, like the example below:

```dart
Text(
    "Hello world!",
    style: context.styles.basic.txt(), // accesses shared app styles
)

ElevatedButton(
    onPressed: ..., // button action
    style: context.styles.basic.btn(), // accesses shared app styles
    child: ..., // button content
)

// container uses "decoration" property
Container(
    decoration: context.styles.basic.box(), // accesses shared app styles
    child: ..., // widget inside container
)
```

Note: make sure to specify the style for all visible widgets, to avoid using flutter default ones, looking inconsistent with the app design.


### Syntax

The styling system uses this syntax:

```dart
context.styles.<styleGroup>.<widgetType>(<parameters>)
```

Every element composing the syntax is described below.

**1. `context.styles`**<br>
To begin, just write `context.styles` to access app styles from code.

**2. `<styleGroup>`**<br>
Then choose the desired style group, that define the **background color** of elements:
- `basic`: for normal elements
- `accent`: for important elements, to be highlighted
- `background`: for less important elements

**3. `<widgetType>`**<br>
Then choose the type of widget you are targeting:
- `txt`: texts and labels
- `btn`: buttons
- `box`: containers

**4. `<parameters>` for `txt` (texts and labels)**<br>
If you wish, add fancy effects:
- `level`, to control text visibility:
  - `1`: faded text
  - `2`: normal text (default)
  - `3`: evident text
- `size` to control text size:
    - `1`: small text (default)
    - `2`: medium text
    - `3`: big text
- `bold`: for bold font

**5. `<parameters>` for `box` and `btn` (containers and buttons)**<br>
- `outline`: add border to the box/button, useful with background style
- `wide`: make box/button wide, to match parent, useful in forms

**6. `<parameters>` for `box` only (containers)**<br>
If you wish, add fancy effects:
- `rounded`: round box borders
- `shadow`: add shadow to the box, for 3D effect

Note: boolen parameters `bold`, `outline`, `wide`, `rounded`, `shadow` default to `false` if not specified.


### Examples

```dart
// styles for texts
context.styles.basic.txt() // default text, on normal element
context.styles.basic.txt(level: 3, size: 3, bold: true) // ultra-visible text
context.styles.accent.txt(level: 3) // evident text, on evident element
context.styles.accent.txt(level: 1) // less evident text, on evident element

// styles for containers
context.styles.accent.box(rounded: true) // rounded evident box
context.styles.background.box(outlined: true) // outlined background box

// styles for buttons
context.styles.basic.btn() // default button
context.styles.accent.btn(wide: true) // visible and wide button
context.styles.background.btn(outline: true) // button with background color
```

See [`lib/dev/styles.dart`](lib/dev/styles.dart) for a complete working example.


### Snackbars

To display temporary messages to the user, `utils/misc.dart` provides useful helper methods, already configured to show a "snack bar" with proper app styles:
- `snackBarText(context, <message>)`: show a snack bar with a text message
- `snackBar(context, <widget>)`: show a snack bar with a custom widget
- `notImplemented(context)`: show a snack bar with a "Not implemented" message


### Direct access to colors

Some widgets don't have a `style` property, but accept only color values.
In this case, you can use colors provided by the chosen style group:
- `backgroundColor`: color of the background
- `fadedTextColor`: color of faded text (level 1)
- `normalTextColor`: color of normal text (level 2)
- `specialTextColor`: color of evident text (level 3)

```dart

// gets style group for the widget
final styleGroup = context.styles.basic;

// uses color of normal text (level 2)
Icon(Icons.add, color: styleGroup.normalTextColor)
```

Note: if available, prefer using the `style` property of the widget, to ensure a consistent design across the app.


### Sizes and spaces

For text sizes, always use the `size` parameter of the `txt` method, to ensure a consistent design across the app.

For other sizes, like **spaces, margins, paddings**, avoid hardcoding numbers into code.
Instead, use the `AppDimensions` class (in `utils/style.dart`), which provides a set of constant dimensions to use in your code: `S` (small), `M` (medium), `L` (large), `X` (extra large), `H` (huge).

For lines, use `AppDimensions.line` to get the default line thickness of the app.
For rounded corners, use `AppDimensions.radius` to get the default corner radius of the app.


### Advanced

Some situations require more complex styles, not covered by the app styles.
In these cases, you can use the `copyWith` method to add custom properties to a style.

```dart
Container(
    decoration: context.styles.basic.box().copyWith( // accesses shared app styles
        BoxDecoration(
            border: Border.all(color: Colors.red), // adds custom property
        ),
    ),
    child: ...,
)
```

If you find yourself using `copyWith` often, consider creating a new style in the app styles database, to keep the code clean and consistent.
