import "package:flutter/material.dart";


// This file contains shared app styles
// For tutorial and exmples: see doc/styles.md
// For full working examle: see lib/dev/styles.md


// Structure of styling system

// The app supports different themes
// Every theme contains 3 style groups: background, basic, accent
// Every group contains styles for different widgets (texts, boxes, buttons)


// app style database, providing 3 style groups
class AppStylesDB {
  final BuildContext ctx;
  AppStylesDB(this.ctx);

  // gets colors from current app theme
  // theme app colors are mapped to style group colors:
  //   - "primary" color is used for background
  //   - "on primary fixed"   color is used for faded   text (level 1)
  //   - "on primary"         color is used for normal  text (level 2)
  //   - "on primary fixed variant" is used for special text (level 3)
  ColorScheme get _scheme => Theme.of(ctx).colorScheme;


  // style group for important elements
  StyleGroup get accent => StyleGroup(
    backgroundColor:  _scheme.primary,
    fadedTextColor:   _scheme.onPrimaryFixed,
    normalTextColor:  _scheme.onPrimary,
    specialTextColor: _scheme.onPrimaryFixedVariant,
  );

  // style group for normal elements
  StyleGroup get basic => StyleGroup(
    backgroundColor:  _scheme.secondary,
    fadedTextColor:   _scheme.onSecondaryFixed,
    normalTextColor:  _scheme.onSecondary,
    specialTextColor: _scheme.onSecondaryFixedVariant,
  );

  // style group for less-evident elements
  StyleGroup get background => StyleGroup(
    backgroundColor:  _scheme.tertiary,
    fadedTextColor:   _scheme.onTertiaryFixed,
    normalTextColor:  _scheme.onTertiary,
    specialTextColor: _scheme.onTertiaryFixedVariant,
  );
}


// easy access to style groups from context
extension BuildContextExtension on BuildContext {
  AppStylesDB get styles => AppStylesDB(this);
}


// app style group, storing color info and text sizes
class StyleGroup {

  final Color backgroundColor;
  final Color fadedTextColor;
  final Color normalTextColor;
  final Color specialTextColor;
  const StyleGroup({
    required this.backgroundColor,
    required this.fadedTextColor,
    required this.normalTextColor,
    required this.specialTextColor
  });


  // gets text color from level (importance)
  Color _textColorFromLevel(int level) {
    if (level < 1 || level > 3) {
      throw ArgumentError("Invalid level. Allowed only 1, 2, 3.");
    }
    return {
      1: fadedTextColor,
      2: normalTextColor,
      3: specialTextColor,
    }[level]!;
  }


  // accessors for widget styles

  // style for text
  TextStyle txt({int level = 2, int size = 1, bool bold = false}) =>
    TextStyle(
      color:    _textColorFromLevel(level),
      fontSize: AppDimensions.textSize(size),
      fontWeight: bold ? FontWeight.bold : null,
    );


  // style for buttons
  ButtonStyle btn({bool outline = false, bool wide = false}) {
    return outline ?
      OutlinedButton.styleFrom(
        foregroundColor: normalTextColor,
        backgroundColor: backgroundColor,
        minimumSize: wide ? Size(double.infinity, AppDimensions.H) : null,
        side: BorderSide(color: normalTextColor),
        shape: RoundedRectangleBorder(borderRadius: AppDimensions.radius),
      ):
      ElevatedButton.styleFrom(
        foregroundColor: normalTextColor,
        backgroundColor: backgroundColor,
        minimumSize: wide ? Size(double.infinity, AppDimensions.H) : null,
      );
  }


  // style for boxes and containers
  BoxDecoration box({
    bool rounded = false,
    bool outline = false,
    bool shadow  = false,
    bool wide    = false,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: rounded ? AppDimensions.radius : null,
      border: outline ? border() : null,
      boxShadow: shadow ? this.shadow() : null,
    );
  }

  // effects for boxes
  Border border() => Border.all(color: normalTextColor, width: AppDimensions.line);
  List<BoxShadow> shadow() => [BoxShadow(color: fadedTextColor, blurRadius: 3)];
}


// database for app dimensions
class AppDimensions {
  static final double S = 4;
  static final double M = 16; // base dimension for text
  static final double L = 24;
  static final double X = 32;
  static final double H = 64;


  // gets text size
  static double textSize(int size) {
    if (size < 1 || size > 3) {
      throw ArgumentError("Invalid size. Allowed only 1, 2, 3.");
    }
    return {1: M, 2: L, 3: X}[size]!;
  }


  // line thickness for borders and separators
  static double get line => 1.5;

  // border radius for boxes
  static BorderRadius get radius => BorderRadius.circular(AppDimensions.M);
}
