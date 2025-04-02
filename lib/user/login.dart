import 'package:flutter/material.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/form.dart';


class LoginForm extends StatefulWidget {
  final VoidCallback toggleForm;
  final Function(BuildContext) onAuth;
  const LoginForm({super.key, required this.toggleForm, required this.onAuth});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {

  // controllers for fields
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  Future<void> _handleLogin() async {
    if (! _formKey.currentState!.validate()) return;

    try {

      // tries login using credentials
      await PocketBaseService().login(_emailController.text, _passwordController.text);
      if (!mounted) return;

      // login completed: go to home page
      widget.onAuth(context);

    // handles errors
    } catch (e) {
      if (mounted) snackBarText(context, 'Login failed: ${e.toString()}');
    }
  }


  // login form
  @override
  Widget build(BuildContext context) {

    return FormWidget(
      formKey: _formKey,
      title: 'Welcome Back',
      fields: [

        // email field
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
          validator: (value) => value!.contains('@') ? null : 'Invalid email',
          textInputAction: TextInputAction.next,
        ),

        // password field
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),

          // submits form on enter press
          textInputAction: TextInputAction.go,
          onEditingComplete: _handleLogin,
        ),
      ],

      // log in button
      submitText: 'Continue',
      onSubmit: _handleLogin,
      
      // sign up text
      hintText: 'New here? Create account',
      onHintClick: widget.toggleForm,
    );
  }
}
