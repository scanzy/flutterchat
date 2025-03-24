
import 'package:flutterchat/utils/misc.dart';
import 'package:intl/intl_standalone.dart';
import 'package:flutter/material.dart';

import 'package:flutterchat/utils/localize.dart';
import 'package:flutterchat/utils/style.dart';


// screen to showcase app localization
class LocalizationPage extends StatefulWidget {
  const LocalizationPage({super.key});

  @override
  State<LocalizationPage> createState() => LocalizationPageState();
}

class LocalizationPageState extends State<LocalizationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localize("localeDemo.title")),
      ),
      body: ScrollableCenterPage(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // example of what you should not do
            _buildDontDoExample(),
            SizedBox(height: 64),

            // example of what you should do
            _buildHowToExample(),
            SizedBox(height: 64),

            // locale selection dropdown
            _buildLocaleSelection(),    
            SizedBox(height: 64),

            // shows device locale settings
            _buildDeviceSettings()
          ],
        ),
      ),
    );
  }


  // example of what you should do
  Widget _buildDontDoExample() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          localize("localeDemo.dontDo"),
          style: AppStyles.textAccent(context, size: 2)
        ),

        // avoid hardcoded strings!
        Text("Hardcoded english string! (Bad)"),
        Text("Stringa fissa, in italiano! (Molto male)"),
      ],
    );
  }


  // example of what you should not do
  Widget _buildHowToExample() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // use localized strings!
        Text(
          localize("localeDemo.howTo.title"),
          style: AppStyles.textAccent(context, size: 2)
        ),
        Text(localize("localeDemo.howTo.hint")),
        Text(localize("localeDemo.howTo.example1")),
        Text(localize("localeDemo.howTo.example2")),
      ],
    );
  }


  // interactive locale selector
  Widget _buildLocaleSelection() {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // title and hint
        Text(
          localize("localeDemo.selection.title"),
          style: AppStyles.textAccent(context, size: 2),
        ),
        Text(localize("localeDemo.selection.hint")),

        SizedBox(height: 24), // space

        // language selection field
        DropdownMenu(
          initialSelection: AppLocalization.currentLocale,
          dropdownMenuEntries: AppLocalization.localesDB.keys.map(
            (locale) => DropdownMenuEntry(value: locale, label: locale),
          ).toList(),

          // updates app locale, used for translation
          onSelected: (selected) => setState(() {
            AppLocalization.setLocale(selected!);
          }),
        ),
      ]
    );
  }


  // show device settings for locale
  Widget _buildDeviceSettings() {

    // gets flutter localization settings (read from device)
    final Locale flutterLocale = Localizations.localeOf(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // title and hint
        Text(
          localize("localeDemo.device.title"),
          style: AppStyles.textAccent(context, size: 2),
        ),
        Text(localize("localeDemo.device.hint")),

        SizedBox(height: 24), // space

        // flutter settings
        Text("Context countryCode: ${flutterLocale.countryCode}"),
        Text("Context languageCode: ${flutterLocale.languageCode}"),
        Text("DateTime timezone: ${DateTime.now().timeZoneName}"),

        // not working on web (from package "dart:io")
        // Text("Platform.localeName: ${Platform.localeName}"),

        SizedBox(height: 24), // space

        // checks system locale
        // the exmple uses button because we need async operation to get locale
        ElevatedButton(
          onPressed: () async {
            final locale = await findSystemLocale();
            if (!mounted) return;
            snackBarText(context, "System locale: $locale");
          },
          style: AppStyles.btnNormal(context),
          child: Text("Check system locale")
        ),
      ],
    );
  }
}
