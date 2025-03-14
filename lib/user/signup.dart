import 'package:flutter/material.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/form.dart';
import 'package:flutterchat/chat/screen.dart';


class SignupForm extends StatefulWidget {
  final VoidCallback toggleForm;
  const SignupForm({super.key, required this.toggleForm});

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

    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      var pb = PocketBaseService();
      await pb.client.collection('users').create(body: {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'passwordConfirm': _confirmController.text,
        },
      );

      await pb.client.collection('users').authWithPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString()}')),
        );
      }
    }
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
