import 'package:flutter/material.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/style.dart';


// bottom input bar of the chat
class ChatInputBar extends StatefulWidget {
  final VoidCallback onMessageSent;

  const ChatInputBar({
    super.key,
    required this.onMessageSent,
  });

  @override
  State<ChatInputBar> createState() => ChatInputBarState();
}


class ChatInputBarState extends State<ChatInputBar> {

  // controller for new message field
  final _messageController = TextEditingController();


  // displays bottom bar with new message field
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.end,
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLines: null,
            onSubmitted: (_) => _sendMessage(),
          ),
        ),
        IconButton(
          iconSize: 32,
          icon: const Icon(Icons.send),
          style: AppStyles.btnAccent(context),
          onPressed: _sendMessage,
        ),
      ],
    );
  }


  // sends a new message to the server
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      // sends message
      await PocketBaseService().sendMessage(_messageController.text.trim());
      if (!mounted) return;

      // empties the new message field
      _messageController.clear();

      // notifies parent widgets
      widget.onMessageSent();
      
      // TODO: clear unread messages on server

    } catch (e) {
      if (!mounted) return;

      // displays error
      snackBarText(context, 'Failed to send message: ${e.toString()}');
    }
  }
}


// a little dialog box to edit the original message
class EditMessageDialog extends StatelessWidget {
  final String initialText;

  const EditMessageDialog({super.key, required this.initialText});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialText);

    return AlertDialog(
      title: const Text('Edit Message'),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: AppStyles.btnNormal(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text),
          style: AppStyles.btnAccent(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
