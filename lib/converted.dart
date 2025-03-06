import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'pb_service.dart';


class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _showLogin = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      var pb = PocketBaseService();
  
      if (pb.client.authStore.isValid) {
        await pb.client.collection('users').authRefresh();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }
        return;
      }
    } catch (e) {
      print('Auth check error: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen()
        : AuthScreen(
            showLogin: _showLogin,
            toggleForm: () => setState(() => _showLogin = !_showLogin),
          );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF00AFA9)),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  final bool showLogin;
  final VoidCallback toggleForm;

  const AuthScreen({
    super.key,
    required this.showLogin,
    required this.toggleForm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: showLogin 
              ? LoginForm (toggleForm: toggleForm)
              : SignupForm(toggleForm: toggleForm),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final VoidCallback toggleForm;

  const LoginForm({super.key, required this.toggleForm});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await PocketBaseService().client.collection('users').authWithPassword(
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
            const Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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

class SignupForm extends StatefulWidget {
  final VoidCallback toggleForm;

  const SignupForm({super.key, required this.toggleForm});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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
        });
        
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
            const Text('Get Started', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final PocketBaseService pb = PocketBaseService();
  final _messageController = TextEditingController();
  final List<RecordModel> _messages = [];
  late final UnsubscribeFunc _unsubscribe;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupRealtime();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final result = await pb.client.collection('messages').getFullList(
      sort: '+created',
      expand: 'user',
    );
    setState(() => _messages.addAll(result.reversed));
  }

  Future<void> _setupRealtime() async {
    _unsubscribe = await pb.client.collection('messages').subscribe('*', (e) async {
      if (e.record == null) return;

      if (e.action == "delete") {
        _handleMessage(e.record as RecordModel, e.action);
        return;
      }

      try {
        var msg = await pb.client.collection('messages').getOne(e.record!.id, expand: 'user');
        _handleMessage(msg, e.action);
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: ${err.toString()}')),
        );
      }
    });
  }

  void _handleMessage(RecordModel msg, String action) {
    switch (action) {
      case 'create':
        setState(() => _messages.insert(0, msg));
        break;
      case 'update':
        final index = _messages.indexWhere((m) => m.id == msg.id);
        if (index != -1) {
          setState(() => _messages[index] = msg);
        }
        break;
      case 'delete':
        setState(() => _messages.removeWhere((m) => m.id == msg.id));
        break;
      default:
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      try {
        await pb.client.collection('messages').create(body: {
          'user': pb.userId,
          'message': _messageController.text.trim(),
        });
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _logout() async {
    pb.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La forza del lupo è il Branco'),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.logOut),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isOwn = message.data['user'] == pb.userId;
                final user = message.get<RecordModel>("expand.user");
                
                return MessageBubble(
                  message: message.data['message'] ?? '',
                  isOwn: isOwn,
                  username: user.data['username']?.toString() ?? 'Unknown',
                  timestamp: DateTime.parse(message.get<String>("created")),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1F2C34),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(FeatherIcons.send),
                  color: const Color(0xFF00AFA9),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isOwn;
  final String username;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwn,
    required this.username,
    required this.timestamp,
  });


  @override
  Widget build(BuildContext context) {
    final color = _generateColor(username);
    return Align(
      alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        
        // max message width: 90% of parent
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.9),
        decoration: BoxDecoration(

          // TODO: use theme colors
          color: isOwn ? const Color(0xFF007B73) : const Color(0xFF1F2C34),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Username with generated color
            Text(
              username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isOwn ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 4),

            // Message text with URL detection
            _parseLinks(message, Colors.white),
            const SizedBox(height: 4),

            // Timestamp
            Text(
              DateFormat('HH:mm').format(timestamp),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white54, // TODO: use theme colors
              ),
            ),
          ],
        ),
      ),
    );
  }


  // composes rich text, recognizing links
  Widget _parseLinks(String text, Color color) {
    final urlRegex = RegExp(r'(https?://[^\s]+)');
    final spans = <TextSpan>[];

    text.splitMapJoin(
      urlRegex,
      onMatch: (match) {
        final url = match.group(0)!;
        spans.add(TextSpan(
          text: url,
          style: const TextStyle(
            color: Colors.blueAccent,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(Uri.parse(url)),
        ));
        return '';
      },
      onNonMatch: (text) {
        spans.add(TextSpan(text: text, style: TextStyle(color: color)));
        return '';
      },
    );

    return RichText(text: TextSpan(children: spans));
  }


  // generates color from string
  Color _generateColor(String seed) {
    final hash = seed.hashCode;
    return HSLColor.fromAHSL(
      1.0,
      (hash % 360).toDouble(),
      0.7,
      0.5,
    ).toColor();
  }
}
