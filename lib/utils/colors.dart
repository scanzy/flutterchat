import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:shared_preferences/shared_preferences.dart";



class AppColors {

  // basic colors
  // NOTE: do not use these colors directly in app, use styles (see doc/styles.md)

  static final Color white       = Colors.white;
  static final Color yellowLight = const Color.fromARGB(255, 255, 252, 222);
  static final Color yellow      = Colors.yellow.shade500;
  static final Color yellowDark  = const Color.fromARGB(255, 214, 202, 24);
  static final Color blackFaded  = Colors.grey.shade600;
  static final Color deep        = Colors.grey.shade800;
  static final Color black       = Colors.black;

  static final Color whiteFaded  = Colors.grey.shade400;
  static final Color aqua        = Color.fromARGB(255, 104, 216, 212); // for important text
  static final Color teal        = Color(0xFF007B73); // for important elements
}


// app themes
Map<String, ThemeData> appThemes = {
  "teal":    tealTheme, // for dev
  "light":   lightTheme,
  "dark":    darkTheme,
  "realmen": realmenTheme,
};


// app font (monospace)
// TODO: bundle file in build
// see here: https://pub.dev/packages/google_fonts#bundling-fonts-when-releasing
final textTheme = GoogleFonts.robotoMonoTextTheme(TextTheme());


// TODO: teal theme
ThemeData tealTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.light(

    // background for elements
    primary:   AppColors.teal, // accent
    secondary: AppColors.deep, // basic
    tertiary:  AppColors.black, // background

    // text for accent elements
    onPrimary:                AppColors.whiteFaded, // normal
    onPrimaryFixed:           AppColors.deep, // faded
    onPrimaryFixedVariant:    AppColors.white, // special

    // text for basic elements
    onSecondary:              AppColors.white,  // normal
    onSecondaryFixed:         AppColors.blackFaded, // faded
    onSecondaryFixedVariant:  AppColors.aqua, // special

    // text for background elements
    onTertiary:               AppColors.whiteFaded,  // normal
    onTertiaryFixed:          AppColors.deep, // faded
    onTertiaryFixedVariant:   AppColors.aqua, // special
  ),

  // app background
  scaffoldBackgroundColor: AppColors.black,

  // title bar
  appBarTheme: AppBarTheme(
    foregroundColor: AppColors.white,
    backgroundColor: AppColors.deep,
    shadowColor:     AppColors.deep,
  ),

  // forms
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor:  AppColors.black,
    labelStyle: TextStyle(color: AppColors.whiteFaded),
    hintStyle:  TextStyle(color: AppColors.deep),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor:          AppColors.whiteFaded,
    selectionColor:       AppColors.teal,
    selectionHandleColor: AppColors.white,
  ),
  textTheme: textTheme.copyWith(
    bodyLarge: TextStyle(color: AppColors.white), // input field text style
  ),
);


// light theme
ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.light(

    // background for elements
    primary:   AppColors.blackFaded,  // accent
    secondary: AppColors.yellow,      // basic
    tertiary:  AppColors.yellowLight, // background

    // text for accent elements
    onPrimary:                AppColors.yellowLight, // normal
    onPrimaryFixed:           AppColors.black, // faded
    onPrimaryFixedVariant:    AppColors.yellow, // special

    // text for basic elements
    onSecondary:              AppColors.blackFaded,  // normal
    onSecondaryFixed:         AppColors.yellowDark, // faded
    onSecondaryFixedVariant:  AppColors.black, // special

    // text for background elements
    onTertiary:               AppColors.blackFaded,  // normal
    onTertiaryFixed:          AppColors.yellowDark,  // faded
    onTertiaryFixedVariant:   AppColors.black, // special
  ),

  // app background
  scaffoldBackgroundColor: AppColors.yellowLight,

  // title bar
  appBarTheme: AppBarTheme(
    foregroundColor: AppColors.deep,
    backgroundColor: AppColors.yellow,
    shadowColor:     AppColors.blackFaded,
  ),

  // forms
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor:  AppColors.yellowLight,
    labelStyle: TextStyle(color: AppColors.deep),
    hintStyle:  TextStyle(color: AppColors.blackFaded),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor:          AppColors.deep,
    selectionColor:       AppColors.yellow,
    selectionHandleColor: AppColors.deep,
  ),
  textTheme: textTheme.copyWith(
    bodyLarge: TextStyle(color: AppColors.black), // input field text style
  ),
);


// dark theme
ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.dark(

    // background for elements
    primary:   AppColors.yellowDark, // accent
    secondary: AppColors.deep, // basic
    tertiary:  AppColors.black, // background

    // text for accent elements
    onPrimary:                AppColors.black, // normal
    onPrimaryFixed:           AppColors.yellow, // faded
    onPrimaryFixedVariant:    AppColors.white, // special

    // text for basic elements
    onSecondary:              AppColors.yellowDark,  // normal
    onSecondaryFixed:         AppColors.blackFaded, // faded
    onSecondaryFixedVariant:  AppColors.white, // special

    // text for background elements
    onTertiary:               AppColors.yellowLight,  // normal
    onTertiaryFixed:          AppColors.blackFaded, // faded
    onTertiaryFixedVariant:   AppColors.yellow, // special
  ),

  // app background
  scaffoldBackgroundColor: AppColors.black,

  // title bar
  appBarTheme: AppBarTheme(
    foregroundColor: AppColors.yellowLight,
    backgroundColor: AppColors.deep,
    shadowColor:     AppColors.black,
  ),

  // forms
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor:  AppColors.black,
    labelStyle: TextStyle(color: AppColors.black),
    hintStyle:  TextStyle(color: AppColors.blackFaded),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor:          AppColors.white,
    selectionColor:       AppColors.blackFaded,
    selectionHandleColor: AppColors.white,
  ),
  textTheme: textTheme.copyWith(
    bodyLarge: TextStyle(color: AppColors.white), // input field text style
  ),
);


// realmen theme (high contrast)
ThemeData realmenTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(

    // background for elements
    primary:   AppColors.black, // accent
    secondary: AppColors.yellowLight, // basic
    tertiary:  AppColors.yellow, // background

    // text for accent elements
    onPrimary:                AppColors.yellow, // normal
    onPrimaryFixed:           AppColors.blackFaded, // faded
    onPrimaryFixedVariant:    AppColors.white, // special

    // text for basic elements
    onSecondary:              AppColors.blackFaded, // normal
    onSecondaryFixed:         AppColors.yellowDark, // faded
    onSecondaryFixedVariant:  AppColors.black, // special

    // text for background elements
    onTertiary:               AppColors.blackFaded,  // normal
    onTertiaryFixed:          AppColors.yellowDark, // faded
    onTertiaryFixedVariant:   AppColors.black, // special
  ),

  // app background
  scaffoldBackgroundColor: AppColors.yellow,

  // title bar
  appBarTheme: AppBarTheme(
    foregroundColor: AppColors.yellowLight,
    backgroundColor: AppColors.black,
    shadowColor:     AppColors.deep,
  ),

  // forms
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor:  AppColors.yellow,
    labelStyle: TextStyle(color: AppColors.black),
    hintStyle:  TextStyle(color: AppColors.deep),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor:          AppColors.black,
    selectionColor:       AppColors.blackFaded,
    selectionHandleColor: AppColors.deep,
  ),
  textTheme: textTheme.copyWith(
    bodyLarge: TextStyle(color: AppColors.black), // input field text style
  ),
);



// handles theme loading/saving
// this setting is stored into device memory
class ThemeController {
  static late final SharedPreferences prefs;

  // singleton pattern
  static final ThemeController _instance = ThemeController._setup();
  factory ThemeController() => _instance; // factory method
  ThemeController._setup(); // private constructor

  // initializer
  Future<void> setup() async => prefs = await SharedPreferences.getInstance();

  // callback to update theme
  static ValueChanged<String>? onThemeChanged;

  // current theme getter
  static String get() => prefs.getString("theme") ?? "auto";

  // current theme setter
  static void set(String newThemeName) {
    prefs.setString("theme", newThemeName);
    onThemeChanged?.call(newThemeName);
  }
}
