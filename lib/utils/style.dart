import "package:flutter/material.dart";


// To create normal boxes:
//    Container(..., decoration: AppStyles.boxNormal(context))

// To create accent boxes:
//    Container(..., decoration: AppStyles.boxAccent(context))

// To add a shadow
//    Container(...,
//      decoration: BoxDecoration(..., 
//        boxShadow: AppStyles.shadow(context)
//    )),

// To create faded text:
//    Text(..., style: AppStyles.textFaded(context))

// To create normal buttons:
//    ElevatedButton(..., style: AppStyles.btnNormal(context))

// To create accent buttons:
//    ElevatedButton(..., style: AppStyles.btnAccent(context))

// To create wide buttons:
//    ElevatedButton(..., style: AppStyles.btnWide(context))

// To create wide accent buttons:
//    ElevatedButton(..., style: AppStyles.btnSubmit(context))

// To add also custom styles:
//    MyWidget(..., style: AppStyles.<something>.merge(<otherstyle>))


class AppColors {

  // colors (dark theme)
  static final Color _white = Colors.white70;   // for normal text
  static final Color _light = Colors.white54;   // for faded text
  static final Color _teal = Color(0xFF007B73); // for important elements
  static final Color _dark = Color(0xFF1F2C34); // for normal elements
  static final Color _deep = Color(0xFF0B141A); // for main background

  // theme color getters (for backgrounds)
  static Color normal    (BuildContext ctx) => _scheme(ctx).primary;
  static Color accent    (BuildContext ctx) => _scheme(ctx).secondary;
  static Color background(BuildContext ctx) => _scheme(ctx).surface;

  // theme color getters (for text)
  static Color text      (BuildContext ctx) => _scheme(ctx).onPrimary;
  static Color faded     (BuildContext _) => _light;

  // gets app color set
  static ColorScheme _scheme(BuildContext ctx) => Theme.of(ctx).colorScheme;
}


class AppStyles {

  // texts
  static TextStyle textFaded (BuildContext ctx) => TextStyle(color: AppColors.faded(ctx));
  static TextStyle textAccent(BuildContext ctx) {
    return TextStyle(
      color: AppColors.accent(ctx),
      fontWeight: FontWeight.bold,
    );
  }

  // boxes
  static BoxDecoration boxNormal(BuildContext ctx) => box(ctx, AppColors.normal(ctx));
  static BoxDecoration boxAccent(BuildContext ctx) => box(ctx, AppColors.accent(ctx));

  static BoxDecoration box(BuildContext ctx, Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
    );
  }

  // buttons
  static ButtonStyle btnNormal(BuildContext ctx) => btn(ctx, AppColors.normal(ctx));
  static ButtonStyle btnAccent(BuildContext ctx) => btn(ctx, AppColors.accent(ctx));
  static ButtonStyle btnWide  (BuildContext ctx) => btn(ctx, null, wide: true);
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
    onSecondary: AppColors._white,

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
);
