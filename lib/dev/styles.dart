
import 'package:flutter/material.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/colors.dart';


// screen to show app colors and styles
class StylesPage extends StatelessWidget {
  const StylesPage({super.key});


  @override
  Widget build(BuildContext context) {

    // style for text size demo
    final sizeDemoStyle = context.styles.background;

    return Scaffold(
      appBar: AppBar(
        title: Text("App styles (theme: ${ThemeController.get()})"),
        actions: [

          // theme control buttons
          ...{
            "auto":    Icons.auto_awesome,
            "light":   Icons.light_mode,
            "dark":    Icons.dark_mode,
            "realmen": Icons.highlight,
            "teal":    Icons.brush_sharp,
          }
          .entries.map(
            (entry) => IconButton(

              // theme name and icon
              icon: Icon(entry.value),
              tooltip: "${entry.key.toCapitalized()} theme",

              // activates theme on click
              onPressed: () => ThemeController.set(entry.key),
            )
          ),
            
          // prevents action buttons overlapping
          debugBannerSpace(),
        ]
      ),
      body: ScrollableCenterPage(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // text size examples
            Text("Large text (size: 3)",  style: sizeDemoStyle.txt(size: 3)),
            Text("Medium text (size: 2)", style: sizeDemoStyle.txt(size: 2)),
            Text("Small text (size: 1)",  style: sizeDemoStyle.txt(size: 1)),

            SizedBox(height: AppDimensions.X), // separator

            // styles group examples
            Row(
              spacing: AppDimensions.H,
              children: [
                _buildStyleCard(context, "basic",      context.styles.basic),
                _buildStyleCard(context, "accent",     context.styles.accent),
                _buildStyleCard(context, "background", context.styles.background),
              ]
            ),
          ],
        ),
      ),
    );
  }


  // draws sample widgets for the specified style group
  Widget _buildStyleCard(BuildContext context, String name, StyleGroup styleGroup) {
    return Expanded(child: Column(
      spacing: AppDimensions.M,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // style title
        Text(
          "${name.toCapitalized()} style group",
          style: context.styles.background.txt(size: 2),
        ),

        // box with sample texts and boxes
        Container(
          decoration: styleGroup.box(rounded: true),
          padding: EdgeInsets.all(AppDimensions.M),
          child: _buildSampleWidgets(context, styleGroup),
        ),

        // sample buttons
        ..._buildSampleButtons(context, styleGroup),
      ]
    ));
  }


  Widget _buildSampleWidgets(BuildContext context, StyleGroup styleGroup) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // text colors examples

        Text("Faded text (level: 1)",  style: styleGroup.txt(level: 1)),
        Text("Normal text (level: 2)", style: styleGroup.txt(level: 2)),
        Text("Accent text (level: 3)", style: styleGroup.txt(level: 3)),

        SizedBox(height: AppDimensions.M), // separator

        // box examples
        Row(
          spacing: AppDimensions.L,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: styleGroup.box(shadow: true),
              padding: EdgeInsets.all(AppDimensions.M),
              child: Text("Box with shadow", style: styleGroup.txt()),
            ),

            Container(
              decoration: styleGroup.box(outline: true),
              padding: EdgeInsets.all(AppDimensions.M),
              child: Text("Box with outline", style: styleGroup.txt()),
            ),
          ],
        ),
      ],
    );
  }

  // button examples
  List<Widget> _buildSampleButtons(BuildContext context, StyleGroup styleGroup) {
    return [ 
      Row(
        spacing: AppDimensions.M,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          ElevatedButton(
            onPressed: () { },
            style: styleGroup.btn(),
            child: Text("Normal button"),
          ),

          OutlinedButton(
            onPressed: () { },
            style: styleGroup.btn(outline: true),
            child: Text("Outlined button"),
          ),
        ],
      ),

      ElevatedButton(
        onPressed: () { },
        style: styleGroup.btn(wide: true),
        child: Text("Wide button"),
      ),
    ];
  }
}
