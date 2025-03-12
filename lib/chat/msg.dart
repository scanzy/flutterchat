import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/chat/input.dart';
import 'package:flutterchat/user/profile.dart';


// widget for one message
class MessageBubble extends StatefulWidget {
  final String messageId;
  final String message;
  final bool isOwn;
  final String userId;
  final String username;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.messageId,
    required this.message,
    required this.isOwn,
    required this.userId,
    required this.username,
    required this.timestamp,
  });

  @override
  State<MessageBubble> createState() => MessageBubbleState();


  // displays message
  static MessageBubble fromModel(RecordModel message) {
    final isOwn = message.data['user'] == PocketBaseService().userId;
    final user = message.get<RecordModel>("expand.user");

    return MessageBubble(
      messageId: message.id,
      message: message.data['message'] ?? '',
      isOwn: isOwn,
      userId: user.id,
      username: user.data['username']?.toString() ?? 'Unknown',
      timestamp: DateTime.parse(message.get<String>("created")),
    );
  }
}


class MessageBubbleState extends State<MessageBubble> {
  late bool _isDesktop;

  // flag to show context menu with action buttons
  bool _showActions = false;
  void toggleShowActions() { _showActions = !_showActions; }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Detect platform when dependencies changes
    _isDesktop = Theme.of(context).platform != TargetPlatform.android &&
        Theme.of(context).platform != TargetPlatform.iOS;
  }


  @override
  Widget build(BuildContext context) {

    // color for username (based on username)
    final usernameColor = _generateColor(widget.username);

    return MouseRegion(
      // shows contect menu when long-tapping or right-click the MessageBubble
      onExit: _isDesktop ? (_) { setState(() => _showActions = false); } : null,
      child: GestureDetector(
        onSecondaryTap: _isDesktop ? () => setState(toggleShowActions) : null,
        onLongPress:   !_isDesktop ? () => setState(toggleShowActions) : null,

        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: widget.isOwn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: const EdgeInsets.all(12),

                // max message width: 90% of parent
                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.9),

                // TODO: use theme colors
                decoration: BoxDecoration(
                color: widget.isOwn ? const Color(0xFF007B73) : const Color(0xFF1F2C34),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Username with generated color
                    Text(
                      widget.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: widget.isOwn ? Colors.white : usernameColor,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Message text with URL detection
                    _parseLinks(widget.message, Colors.white),
                    const SizedBox(height: 4),

                    // Timestamp
                    Text(
                      DateFormat('HH:mm').format(widget.timestamp),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white54, // TODO: use theme colors
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // shows context menu overlay
            if (_showActions) _buildContextMenu(),
          ],
        ),
      ),
    );
  }


  // composes rich text, recognizing links and formatting them
  Widget _parseLinks(String text, Color color) {
    final urlRegex = RegExp(r'(https?://[^\s]+)');
    final spans = <TextSpan>[];

    text.splitMapJoin(
      urlRegex,

      // formats links properly
      onMatch: (match) {
        final url = match.group(0)!;
        spans.add(TextSpan(
            text: url,
            style: const TextStyle(
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
            ),

          // opens link in browser on tap
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(Uri.parse(url)),
        ));
        return '';
      },

      // leaves other text untouched
      onNonMatch: (text) {
        spans.add(TextSpan(text: text, style: TextStyle(color: color)));
        return '';
      },
    );

    // composes text joining processed chuncks
    return RichText(text: TextSpan(children: spans));
  }


  // generates color from string
  Color _generateColor(String seed) {
    final hash = seed.hashCode;
    return HSLColor.fromAHSL(1.0, (hash % 360).toDouble(), 0.7, 0.5).toColor();
  }


  // context menu for messages
  Widget _buildContextMenu() {
    return Positioned(
      top: 0,
      // handle the position depending on the MessageBubble
      right: widget.isOwn ? 20 : null,
      left: widget.isOwn ? null : 20,
      child: ActionButtonsMenu(actions: [
        ActionButton(icon: Icons.reply, onPressed: _handleReply),
        if (widget.isOwn)
          ActionButton(icon: Icons.edit, onPressed: _handleEdit),
        ActionButton(icon: Icons.push_pin, onPressed: _handlePin),
        ActionButton(
          icon: Icons.person,
          onPressed: () => navigateToPage(
            context, ProfileScreen(userId: widget.userId)),
        ),
        if (widget.isOwn)
          ActionButton(icon: Icons.delete, onPressed: _handleDelete),
      ]),
    );
  }


  // called when edit action is selected
  Future<void> _handleEdit() async {

    // asks for edited message (with dialog)
    final newContent = await showDialog<String>(
      context: context,
      builder: (context) => EditMessageDialog(initialText: widget.message),
    );
    if (newContent == null) return;

    try {
      await PocketBaseService().updateMessage(widget.messageId, newContent);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Edit failed: ${e.toString()}')));
    }
  }


  // called when reply to message is selected
  Future<void> _handleReply() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Not implemented')));
  }


  // called when pin message is selected
  Future<void> _handlePin() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Not implemented')));
  }


  // called when delete to message is selected
  Future<void> _handleDelete() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Not implemented')));
  }
}


// single option for context menu
class ActionButton {
  final IconData icon;
  final VoidCallback? onPressed;
  const ActionButton({required this.icon, this.onPressed});
}


// menu with action buttons
class ActionButtonsMenu extends StatelessWidget {
  final List<ActionButton> actions;
  const ActionButtonsMenu({super.key, required this.actions});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A3942),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: actions.map((action) =>
          IconButton(
            icon: Icon(action.icon, size: 18),
            color: Colors.white70,
            onPressed: action.onPressed,
          )
        ).toList()
      ),
    );
  }
}
