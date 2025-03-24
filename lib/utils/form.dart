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
      style: AppStyles.textNormal(context, size: 2),
      textAlign: TextAlign.center,
    );
  }


  // submit button
  Widget _buildSubmit(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      style: AppStyles.btnSubmit(context),
      child: Text(submitText!),
    );
  }


  // hint
  Widget _buildHint(BuildContext context) {
    return TextButton(
      onPressed: onHintClick,
      child: Text(
        hintText!,
        style: AppStyles.textAccent(context),
        textAlign: TextAlign.center,
      ),
    );
  }


  // form box 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin:  const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: AppStyles.boxNormal(context),

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
