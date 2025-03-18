import 'package:flutter/material.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/form.dart';


class SignupForm extends StatefulWidget {
  final VoidCallback toggleForm;
  final Function(BuildContext) onAuth;
  const SignupForm({super.key, required this.toggleForm, required this.onAuth});

  @override
  SignupFormState createState() => SignupFormState();
}


class SignupFormState extends State<SignupForm> {

  // field controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();


  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    // validates password
    if (_passwordController.text != _confirmController.text) {
      snackBarText(context, 'Passwords do not match');
      return;
    }

    var pb = PocketBaseService();
    try {
      // creates account
      await pb.client.collection('users').create(body: {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'passwordConfirm': _confirmController.text,
        },
      );
    } catch (e) {
      if (mounted) snackBarText(context, 'Signup failed: ${e.toString()}');
      return;
    }
    if (!mounted) return;

    // and logs in
    await pb.login(_emailController.text, _passwordController.text);
    if (!mounted) return;

    // login completed: go to homepage
    widget.onAuth(context);
  }


  // signup form
  @override
  Widget build(BuildContext context) {
    return FormWidget(
      formKey: _formKey,
      title: 'Get Started',
      fields:  [
            
        // username field
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            filled: true,
          ),
          validator: (value) => value!.isEmpty ? 'Enter username' : null,
        ),

        // email field
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
          ),
          validator: (value) => value!.contains('@') ? null : 'Invalid email',
        ),

        // password field
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            filled: true,
          ),
        ),

        // confirm password field
        TextFormField(
          controller: _confirmController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            filled: true,
          ),
        ),

        // TODO: add personal info (maybe in other page)
      ],

      // sing up button
      submitText: 'Create Account',
      onSubmit: _handleSignup,

      // log in hint
      onHintClick: widget.toggleForm,
      hintText: "Already have an account? Sign in",
    );
  }
}
