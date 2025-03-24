import "package:flutter/material.dart";


// This file contains app colors and styles


/*
To create normal small text:
    Text(..., style: AppStyles.textNormal(context, size: 1))

To create normal medium-size text:
    Text(..., style: AppStyles.textNormal(context, size: 2))

To create normal large text:
    Text(..., style: AppStyles.textNormal(context, size: 3))

To create accent text (small/medium/large):
    Text(..., style: AppStyles.textAccent(context, size: 1/2/3))

To create faded text (small/medium/large):
    Text(..., style: AppStyles.textFaded(context, size: 1/2/3))

To create normal boxes:
    Container(..., decoration: AppStyles.boxNormal(context))

To create accent boxes:
    Container(..., decoration: AppStyles.boxAccent(context))

To add a shadow to normal (or accent) boxes:
    Container(...,
      decoration: AppStyles.boxNormal(context).copyWith( 
        boxShadow: AppStyles.shadow(context)
    ))

To add a shadow to custom boxes:
    Container(...,
      decoration: BoxDecoration(..., 
        boxShadow: AppStyles.shadow(context)
    ))

To create normal buttons:
    ElevatedButton(..., style: AppStyles.btnNormal(context))

To create accent buttons:
    ElevatedButton(..., style: AppStyles.btnAccent(context))

To create wide accent buttons:
    ElevatedButton(..., style: AppStyles.btnSubmit(context))

To add also custom styles to buttons:
    ElevatedButton(..., style: AppStyles.btnNormal(context).merge(
      ElevatedButton.styleFrom(
        <otherstyle>
    ))
*/


class AppColors {

  // basic colors (dark theme)
  // NOTE: do not use these colors directly in app

  static final Color _white = Colors.white70;     // for normal text
  static final Color _fade = Colors.white38;    // for faded text
  static final Color _aqua = Color(0xFF00AFA9); // for important text
  static final Color _teal = Color(0xFF007B73); // for important elements
  static final Color _dark = Color(0xFF1F2C34); // for normal elements
  static final Color _deep = Color(0xFF0B141A); // for main background

  // gets app color set
  static ColorScheme _scheme(BuildContext ctx) => Theme.of(ctx).colorScheme;


  // theme color getters
  // NOTE: use these colors in app! To provide light/dark theme functionality
 
  // for backgrounds
  static Color normal    (BuildContext ctx) => _scheme(ctx).primary;
  static Color accent    (BuildContext ctx) => _scheme(ctx).secondary;
  static Color background(BuildContext ctx) => _scheme(ctx).surface;

  // for text
  static Color text (BuildContext ctx) => _scheme(ctx).onPrimary;
  static Color light(BuildContext ctx) => _scheme(ctx).onSecondary;
  static Color faded(BuildContext ctx) => _scheme(ctx).onTertiary;
}


// app style database
// NOTE: use these styles in app! This ensures consistent styling across widgets

class AppStyles {

  // text colors
  static TextStyle textNormal(BuildContext ctx, {int size = 1}) =>
    _build(ctx, color: AppColors.text, size: size);

  static TextStyle textFaded (BuildContext ctx, {int size = 1}) =>
    _build(ctx, color: AppColors.faded, size: size);

  static TextStyle textAccent(BuildContext ctx, {int size = 1}) =>
    _build(ctx, color: AppColors.light, size: size)
      .merge(TextStyle(fontWeight: FontWeight.bold));


  // text sizes
  static TextStyle textSize(int size, BuildContext ctx) {
    final textTheme = Theme.of(ctx).textTheme;
    return <int, TextStyle?>{
      1: textTheme.bodyMedium,
      2: textTheme.headlineMedium,
      3: textTheme.displayMedium,
    }[size]!;
  }

  // builds text style combining color and size
  static TextStyle _build(BuildContext ctx,
    {required Function(BuildContext) color, required int size}) =>
      textSize(size, ctx).merge(TextStyle(color: color(ctx)));


  // box colors
  static BoxDecoration boxNormal(BuildContext ctx) => box(ctx, AppColors.normal(ctx));
  static BoxDecoration boxAccent(BuildContext ctx) => box(ctx, AppColors.accent(ctx));

  static BoxDecoration box(BuildContext ctx, Color color) =>
    BoxDecoration(color: color, borderRadius: BorderRadius.circular(15));


  // button colors
  static ButtonStyle btnNormal(BuildContext ctx) => btn(ctx, AppColors.normal(ctx));
  static ButtonStyle btnAccent(BuildContext ctx) => btn(ctx, AppColors.accent(ctx));
  static ButtonStyle btnSubmit(BuildContext ctx) => btn(ctx, AppColors.accent(ctx), wide: true);
                  
  static ButtonStyle btn(BuildContext ctx, Color? color, {bool wide = false}) {
    return ElevatedButton.styleFrom(
      foregroundColor: AppColors.text(ctx),
      backgroundColor: color,
      minimumSize: wide ? const Size(double.infinity, 50) : null,
    );
  }

  // standard shadow
  static List<BoxShadow> shadow(BuildContext context) {
    return [BoxShadow(color: AppColors.background(context), blurRadius: 8)];
  }
}


// builds app theme
ThemeData appTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.dark(

    // text
    onPrimary:   AppColors._white,
    onSecondary: AppColors._aqua,
    onTertiary:  AppColors._fade,

    // elements
    primary:   AppColors._dark,
    secondary: AppColors._teal,
    surface:   AppColors._deep,
  ),

  // app background
  scaffoldBackgroundColor: AppColors._deep,

  // title bar
  appBarTheme: AppBarTheme(
    foregroundColor: AppColors._white,
    backgroundColor: AppColors._dark,
    shadowColor:     AppColors._deep,
  ),

  // forms
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: AppColors._white),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors._white,
  ),
);
