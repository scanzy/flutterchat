
import 'package:flutter/material.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/chat/screen.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback toggleForm;

  const LoginForm({super.key, required this.toggleForm});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await PocketBaseService().client
            .collection('users')
            .authWithPassword(_emailController.text, _passwordController.text);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
        }
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
              'Welcome Back',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AFA9),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            TextButton(
              onPressed: widget.toggleForm,
              child: const Text('New here? Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
