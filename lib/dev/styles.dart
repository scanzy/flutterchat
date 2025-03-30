
import 'package:flutter/material.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';


// screen to show app colors and styles
class StylesPage extends StatelessWidget {
  const StylesPage({super.key});


  @override
  Widget build(BuildContext context) {

    // style for text size demo
    final sizeDemoStyle = context.styles.background;

    return Scaffold(
      appBar: AppBar(
        title: Text("App styles"),
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
  Widget _buildStyleCard(BuildContext context, String name, StyleGroup appStyle) {
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
          decoration: appStyle.box(rounded: true),
          padding: EdgeInsets.all(AppDimensions.M),
          child: _buildSampleWidgets(context, appStyle),
        ),

        // sample buttons
        ..._buildSampleButtons(context, appStyle),
      ]
    ));
  }


  Widget _buildSampleWidgets(BuildContext context, StyleGroup appStyle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // text colors examples

        Text("Faded text (level: 1)",  style: appStyle.txt(level: 1)),
        Text("Normal text (level: 2)", style: appStyle.txt(level: 2)),
        Text("Accent text (level: 3)", style: appStyle.txt(level: 3)),

        SizedBox(height: AppDimensions.M), // separator

        // box examples
        Row(
          spacing: AppDimensions.L,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: appStyle.box(shadow: true),
              padding: EdgeInsets.all(AppDimensions.M),
              child: Text("Box with shadow", style: appStyle.txt()),
            ),

            Container(
              decoration: appStyle.box(outline: true),
              padding: EdgeInsets.all(AppDimensions.M),
              child: Text("Box with outline", style: appStyle.txt()),
            ),
          ],
        ),
      ],
    );
  }

  // button examples
  List<Widget> _buildSampleButtons(BuildContext context, StyleGroup appStyle) {
    return [ 
      Row(
        spacing: AppDimensions.M,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          ElevatedButton(
            onPressed: () { },
            style: appStyle.btn(),
            child: Text("Normal button"),
          ),

          OutlinedButton(
            onPressed: () { },
            style: appStyle.btn(outline: true),
            child: Text("Outlined button"),
          ),
        ],
      ),

      ElevatedButton(
        onPressed: () { },
        style: appStyle.btn(wide: true),
        child: Text("Wide button"),
      ),
    ];
  }
}
