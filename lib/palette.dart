
import 'package:flutter/material.dart';
import 'package:flutterchat/utils/style.dart';


// screen to show theme colors
class PalettePage extends StatelessWidget {
  const PalettePage({super.key});


  // colored circle with text
  Widget _coloredCircle(String text, Color color) {
    return Container(
      padding: EdgeInsets.all(50),
      margin:  EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Text(text),
    );
  }


  @override
  Widget build(BuildContext context) {

    // loads colors from theme
    final Map<String, Color> colors = {
      "Normal":     AppColors.normal(context),
      "Accent":     AppColors.accent(context),
      "Background": AppColors.background(context),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("App colors"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          // builds one circle for each color
          children: colors.entries.map(
            (x) => _coloredCircle(x.key, x.value)
          ).toList(),
        ),
      ),
    );
  }
}
