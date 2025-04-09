import 'package:flutter/material.dart';
import 'package:flutterchat/utils/style.dart';


// reusable form
class FormWidget extends StatelessWidget {

  // form elements
  final String? title;
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;

  // main button
  final String? submitText;
  final VoidCallback? onSubmit;

  // small link
  final String? hintText;
  final VoidCallback? onHintClick;

  const FormWidget({
    super.key,
    this.title,
    required this.formKey,
    required this.fields,
    this.submitText,
    this.onSubmit,
    this.hintText,
    this.onHintClick,
  });


  // form title
  Widget _buildTitle(BuildContext context) {
    return Text(
      title!,
      style: context.styles.basic.txt(size: 2),
      textAlign: TextAlign.center,
    );
  }


  // submit button
  Widget _buildSubmit(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      style: context.styles.accent.btn(wide: true),
      child: Text(submitText!),
    );
  }


  // hint
  Widget _buildHint(BuildContext context) {
    return TextButton(
      onPressed: onHintClick,
      child: Text(
        hintText!,
        style: context.styles.basic.txt(level: 3),
        textAlign: TextAlign.center,
      ),
    );
  }


  // form box 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin:  EdgeInsets.all(AppDimensions.L),
      padding: EdgeInsets.all(AppDimensions.L),
      decoration: context.styles.basic.box(rounded: true),

      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // form title
            if (title != null) ...[
              _buildTitle(context),
              const SizedBox(height: 24),
            ],
      
            // form fields
            for (var field in fields) ...[
              field,
              const SizedBox(height: 16),
            ],
      
            // submit button
            if (submitText != null) ...[
              const SizedBox(height: 16),
              _buildSubmit(context),
            ],

            // hint
            if (hintText != null) ...[
              const SizedBox(height: 16),
              _buildHint(context),
            ],
          ],
        ),
      ),
    );
  }
}
