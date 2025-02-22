// second test (ChatGPT)

import 'package:flutter/material.dart';

class ChatPageTest2 extends StatefulWidget {
  const ChatPageTest2({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatPageTest2> {
  final List<Message> messages = [
    Message(
      username: 'Alice',
      text: 'Hello!',
      isAdmin: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      status: MessageStatus.sent,
    ),
    Message(
      username: 'Bob',
      text: 'Hi there!',
      isAdmin: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
      status: MessageStatus.sent,
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool autoScroll = true;

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add(Message(
        username: 'You',
        text: _controller.text.trim(),
        isAdmin: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      ));
      _controller.clear();
    });
    _animateScroll();
    // TODO: Integrate with PocketBase backend for sending message
  }

  void _animateScroll() {
    if (autoScroll) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageBubble(Message message) {
    return ListTile(
      leading: CircleAvatar(child: Text(message.username[0])),
      title: Row(
        children: [
          Text(
            message.username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getRandomColor(message.username),
            ),
          ),
          SizedBox(width: 5),
          if (message.isAdmin)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              color: Colors.redAccent,
              child: Text('Admin',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
            )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.text),
          SizedBox(height: 4),
          Text(
            message.status == MessageStatus.sending
                ? 'Sending...'
                : 'Sent at ${_formatTime(message.timestamp)}',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          )
        ],
      ),
      onLongPress: () => _showMessageActions(message),
    );
  }

  void _showMessageActions(Message message) {
    // Action buttons: copy, edit, delete (with confirm)
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.copy),
              title: Text('Copy'),
              onTap: () {
                // TODO: Copy message to clipboard
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                // TODO: Populate text field for editing
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                // TODO: Confirm and delete message
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  Color _getRandomColor(String username) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
    return colors[username.hashCode % colors.length];
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branco'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {/* Search */}),
        ],
      ),
      body: Column(
        children: [
          // Unread messages title (placeholder)
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text('${messages.length} unread messages'),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) =>
                  _buildMessageBubble(messages[index]),
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    // TODO: Attach file or image
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                    onTap: () {
                      // Re-enable auto-scroll when interacting
                      autoScroll = true;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

enum MessageStatus { sending, sent }

class Message {
  final String username;
  final String text;
  final bool isAdmin;
  final DateTime timestamp;
  final MessageStatus status;

  Message({
    required this.username,
    required this.text,
    required this.isAdmin,
    required this.timestamp,
    required this.status,
  });
}
