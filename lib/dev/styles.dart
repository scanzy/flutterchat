
import 'package:flutter/material.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';


// screen to show app colors and styles
class StylesPage extends StatelessWidget {
  const StylesPage({super.key});


  @override
  Widget build(BuildContext context) {

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
            Text("Large text (size: 3)",  style: AppStyles.textNormal(context, size: 3)),
            Text("Medium text (size: 2)", style: AppStyles.textNormal(context, size: 2)),
            Text("Small text (size: 1)",  style: AppStyles.textNormal(context, size: 1)),

            SizedBox(height: 64), // separator

            // text colors examples

            Text("Normal text", style: AppStyles.textNormal(context)),
            Text("Accent text", style: AppStyles.textAccent(context)),
            Text("Faded text",  style: AppStyles.textFaded (context)),

            SizedBox(height: 16), // separator


            // box examples

            Container(
              decoration: AppStyles.boxNormal(context),
              padding: EdgeInsets.all(8),
              child: Text("Normal box"),
            ),
            
            SizedBox(height: 16), // separator

            Container(
              decoration: AppStyles.boxAccent(context),
              padding: EdgeInsets.all(8),
              child: Text("Accent box"),
            ),
            
            SizedBox(height: 16), // separator


            // normal box with shadow

            // background just to show the shadow
            Container(
              decoration: BoxDecoration(
                color: AppColors.normal(context),
              ),
              padding: EdgeInsets.all(24),
              child:
              
              // actual box with shadow
              Container(
                // combines normal box style, with shadow
                decoration: AppStyles.boxNormal(context).copyWith(
                  boxShadow: AppStyles.shadow(context),
                ),
                padding: EdgeInsets.all(8),
                child: Text("Box with shadow"),
              ),
            ),

            SizedBox(height: 64), // separator


            // button examples

            ElevatedButton(
              onPressed: () { },
              style: AppStyles.btnNormal(context),
              child: Text("Normal button"),
            ),

            SizedBox(height: 16), // separator

            ElevatedButton(
              onPressed: () { },
              style: AppStyles.btnAccent(context),
              child: Text("Accent button"),
            ),

            SizedBox(height: 16), // separator

            ElevatedButton(
              onPressed: () { },
              style: AppStyles.btnSubmit(context),
              child: Text("Submit button (accent and wide)"),
            ),
          ],

        ),
      ),
    );
  }
}
