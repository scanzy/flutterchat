
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
        padding: EdgeInsets.all(AppDimensions.L),
        child: Column(
          spacing: AppDimensions.M,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // example of what you should not do
            _buildDontDoExample(),

            // example of what you should do
            _buildHowToExample(),

            // locale selection dropdown
            _buildLocaleSelection(),

            // shows device locale settings
            _buildDeviceSettings()
          ],
        ),
      ),
    );
  }


  // card for examples
  Widget _buildCard({
    required StyleGroup style,
    required List<Widget> children,
    bool outline = false,
  }) {

    // rounded box
    return Container(
      decoration: style.box(rounded: true, outline: outline),
      padding: EdgeInsets.all(AppDimensions.M),

      // centered children widgets with small space
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppDimensions.S,
        children: children,
      ),
    );
  }


  // example of what you should do
  Widget _buildDontDoExample() {
    final styleGroup = context.styles.basic;
    return _buildCard(
      style: styleGroup,
      children: [
        Text(
          localize("localeDemo.dontDo"),
          style: styleGroup.txt(level: 3, size: 2),
        ),

        // avoid hardcoded strings!
        Text("Hardcoded english string! (Bad)",          style: styleGroup.txt()),
        Text("Stringa fissa, in italiano! (Molto male)", style: styleGroup.txt()),
      ],
    );
  }


  // example of what you should not do
  Widget _buildHowToExample() {
    final styleGroup = context.styles.accent;
    return _buildCard(
      style: styleGroup,
      children: [

        // use localized strings!
        Text(
          localize("localeDemo.howTo.title"),
          style: styleGroup.txt(level: 3, size: 2),
        ),
        Text(localize("localeDemo.howTo.hint"),     style: styleGroup.txt()),
        Text(localize("localeDemo.howTo.example1"), style: styleGroup.txt()),
        Text(localize("localeDemo.howTo.example2"), style: styleGroup.txt()),
      ],
    );
  }


  // interactive locale selector
  Widget _buildLocaleSelection() {
    final styleGroup = context.styles.basic;
    return _buildCard(
      style: styleGroup,
      children: [

        // title and hint
        Text(
          localize("localeDemo.selection.title"),
          style: styleGroup.txt(level: 3, size: 2),
        ),
        Text(
          localize("localeDemo.selection.hint"),
          style: styleGroup.txt(),
        ),

        SizedBox(height: AppDimensions.M), // space

        // language selection field
        DropdownMenu(
          textStyle: styleGroup.txt(),
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

    final styleGroup = context.styles.background;
    return _buildCard(
      style: styleGroup,
      outline: true,
      children: [

        // title and hint
        Text(
          localize("localeDemo.device.title"),
          style: styleGroup.txt(level: 3, size: 2),
        ),
        Text(
          localize("localeDemo.device.hint"),
          style: styleGroup.txt(),
        ),

        SizedBox(height: AppDimensions.L), // space

        // flutter settings
        ...[
          "Context countryCode:  ${flutterLocale.countryCode}",
          "Context languageCode: ${flutterLocale.languageCode}",
          "DateTime timezone:    ${DateTime.now().timeZoneName}",
        ].map((text) => Text(text, style: styleGroup.txt())),

        // not working on web (from package "dart:io")
        // Text("Platform.localeName: ${Platform.localeName}"),

        SizedBox(height: AppDimensions.L), // space

        // checks system locale
        // the exmple uses button because we need async operation to get locale
        ElevatedButton(
          onPressed: () async {
            final locale = await findSystemLocale();
            if (!mounted) return;
            snackBarText(context, "System locale: $locale");
          },
          style: context.styles.accent.btn(),
          child: Text("Check system locale")
        ),
      ],
    );
  }
}
