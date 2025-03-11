import 'package:flutter/material.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/chat/screen.dart';


class SignupForm extends StatefulWidget {
  final VoidCallback toggleForm;

  const SignupForm({super.key, required this.toggleForm});

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2C34),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Get Started',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor: const Color(0xFF0B141A),
              ),
              validator: (value) => value!.isEmpty ? 'Enter username' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: const Color(0xFF0B141A),
              ),
              validator: (value) => value!.contains('@') ? null : 'Invalid email',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: const Color(0xFF0B141A),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                filled: true,
                fillColor: const Color(0xFF0B141A),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleSignup,
              child: const Text('Create Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AFA9),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            TextButton(
              onPressed: widget.toggleForm,
              child: const Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
