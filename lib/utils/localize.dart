import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';


// localization utilities

// gets the localized version of a string
String  localize    (String  key) => AppLocalization.getDBentry(AppLocalization._currentLocale, key);
String? localizeSafe(String? key) => (key == null) ? null : localize(key);


// formats a date (with time, if you want), with proper localization
// example: formatDateTime(DateFormat.dMMMMy, myDateTime); // gives "1 Gennaio 2025"
String formatDateTime(DateFormat Function(dynamic) format, DateTime dateTime) =>
  format(AppLocalization._currentLocale).format(dateTime);


// type alias for locale database
typedef DBtype = Map<String, String>;


// provides basic localization for the app
class AppLocalization {

  // locale settings
  static String _defaultLocale = "en"; // ignore: prefer_final_fields
  static String _currentLocale = "it";
  static String get currentLocale => _currentLocale;

  // TODO: load current locale from device settings
  // find a way to override this for servers (gitpod dev env and web production)


  // provides initialization for date and time formatting
  static void init() {
    initializeDateFormatting(_currentLocale);
  }

  // sets the current language, getting locale database
  static void setLocale(String countryCode) {
    _currentLocale = countryCode;

    // checks missing keys in database
    checkDB(getDB(_defaultLocale), getDB(_currentLocale));
  }


  // gets the locale database, providing helpful error
  static DBtype getDB(String locale) {
    final db = localesDB[locale];

    // checks if database found
    if (db != null) return db;
    throw ArgumentError("Database not found for locale '$locale'");
  }


  // gets locale entries, providing helpful error
  static String getDBentry(String locale, String key) {
    final entry = getDB(locale)[key];

    // checks if entry found
    if (entry != null) return entry;
    throw ArgumentError("Entry '$key' not found in locale database '$locale'");
  }


  // checks database completeness
  // strict: true  => throws error if databases are not complete
  // strict: false => logs warning if databases are not complete
  static void checkDB(DBtype db1, DBtype db2, {bool strict = true}) {

    // gets keys not present in both maps
    final differentKeys = db1.keys.toSet().difference(db2.keys.toSet());

    // no problem if same keys (databases match!)
    if (differentKeys.isEmpty) return;

    // composes and shows warning or error
    final errText = "Incomplete locale databases, missing keys: ${differentKeys.join(", ")}";

    if (strict) {
      throw ArgumentError(errText);
    } else {
      Logger("Localization").warning(errText);
    }
  }


  // locales database
  // TODO: load from json file (static asset)
  // NOTE: to speed up development, make sure to reload json file on hot reload
  // NOTE: make this happen only in debug mode to optimize performance
  static final Map<String, DBtype> localesDB = {
    "en": enDB,
    "it": itDB,
  };
}


// english strings
DBtype enDB = {

  // localization example
  "localeDemo.title":           "App localization",
  "localeDemo.dontDo":          "Don't to this",
  "localeDemo.howTo.title":     "How to do it",
  "localeDemo.howTo.hint":      "Always use 'localize' method.",
  "localeDemo.howTo.example1":  "This is an example!",
  "localeDemo.howTo.example2":  "This is another example, with dynamic number: {number}.",
  "localeDemo.selection.title": "Locale selection",
  "localeDemo.selection.hint":  "Try to change the current app locale, and see the effect.",
  "localeDemo.device.title":    "Device settings",
  "localeDemo.device.hint":     "App locale is not linked to device settings (for now).",

  // shared
  "shared.title": "Realmen app",

  // chat screen
  "chat.pin.multi":
    "Can't pin message because another message is already pinned. "
    "Unpin the other message and try again.",
};


// italian strings
DBtype itDB = {

  // localization example
  "localeDemo.title":           "Lingua della app",
  "localeDemo.dontDo":          "Cosa non fare",
  "localeDemo.howTo.title":     "Come fare",
  "localeDemo.howTo.hint":      "Utilizzare sempre il metodo 'localize'.",
  "localeDemo.howTo.example1":  "Questo è un esempio!",
  "localeDemo.howTo.example2":  "Questo è un altro esempio, con un numero dinamico: {number}.",
  "localeDemo.selection.title": "Selezione lingua",
  "localeDemo.selection.hint":  "Prova a cambiare la lingua corrente della app, e guarda l'effetto.",
  "localeDemo.device.title":    "Impostazioni del dispositivo",
  "localeDemo.device.hint":     "La lingua della app (per ora) è indipendente dalle impostazioni del dispositivo.",    

  // shared
  "shared.title": "App Realmen",

  // chat screen
  "chat.pin.multi":
      "Impossibile fissare il messaggio perchè c'è già un altro messaggio fissato in alto. "
      "Rimuovi il messaggio già fissato in alto e riprova.",
};
