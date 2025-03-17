import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/chat/input.dart';
import 'package:flutterchat/user/profile.dart';


// object for messages
class Message {
  late final String id;
  late final String text;
  late final bool   pinned;
  late final String userId;
  late final String username;
  late final bool   isOwn;
  late final DateTime created;

  // gets data from message record
  Message(RecordModel record) {
    final user = record.get<RecordModel>("expand.user");

    id       = record.id;
    text     = record.get<String?>('message') ?? '';
    pinned   = record.get<bool?>('pinned') ?? false;
    userId   = user.id;
    username = user.get<String?>('username') ?? 'Unknown';
    isOwn    = userId == PocketBaseService().userId;
    created  = DateTime.parse(record.get<String>("created"));
  }

  DateTime get date => DateTime(created.year, created.month, created.day);
}


// widget for one message
class MessageBubble extends StatefulWidget {
  final Message msg;
  final VoidCallback handlePin;
  final VoidCallback handleEdit;
  final VoidCallback handleReply;

  const MessageBubble({
    super.key,
    required this.msg,
    required this.handlePin,
    required this.handleEdit,
    required this.handleReply,
  });

  @override
  State<MessageBubble> createState() => MessageBubbleState();

  String get messageId  => msg.id;
  String get text       => msg.text;
  String get userId     => msg.userId;
  bool   get pinned     => msg.pinned;
  String get username   => msg.username;
  bool   get isOwn      => msg.isOwn;
  DateTime get created  => msg.created;

  // checks if current user is admin (and can delete/pin messages)
  bool get isAdmin => PocketBaseService().isAdmin;
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
    _isDesktop = ![TargetPlatform.iOS, TargetPlatform.android]
      .contains(Theme.of(context).platform);
  }


  @override
  Widget build(BuildContext context) {

    // color for username (based on username)
    final usernameColor = widget.isOwn ?
      AppColors.text(context) : generateColor(widget.username);

    // style for message bubble
    final bubbleStyle = widget.isOwn ?
      AppStyles.boxAccent(context) : AppStyles.boxNormal(context);

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
                decoration: bubbleStyle,
                margin:  const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: const EdgeInsets.all(12),

                // max message width: 90% of parent
                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.9),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Username with generated color
                    RichText(
                      text: TextSpan(
                        text: widget.username,
                        style: TextStyle(
                          color: usernameColor,
                          fontWeight: FontWeight.bold,
                        ),

                        // opens profile page on username click
                        recognizer: TapGestureRecognizer()
                          ..onTap = () { navigateToPage(
                            context, ProfileScreen(userId: widget.userId)); },
                      ),
                    ),

                    // Message text with URL detection
                    const SizedBox(height: 4),
                    parseLinks(widget.text),
                    const SizedBox(height: 4),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // timestamp
                        Text(
                          DateFormat('HH:mm').format(widget.created),
                          style: AppStyles.textFaded(context),
                        ),

                        // pin icon (for pinned messages)
                        if (widget.pinned) ...[
                          SizedBox(width: 4),
                          Icon(
                            Icons.push_pin,
                            size: 16,
                            color: AppColors.text(context),
                          ),
                        ]
                      ],
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


  // context menu for messages
  Widget _buildContextMenu() {
    return Positioned(
      top: 0,
      // handle the position depending on the MessageBubble
      right: widget.isOwn ? 20 : null,
      left:  widget.isOwn ? null : 20,
      child: ActionButtonsMenu(

        // hides menu on selection
        onSelection: () { setState(() { _showActions = false; }); },
        actions: [

        ActionButton(
          text: "Reply",
          icon: Icons.reply,
          onPressed: widget.handleReply,
        ),

        if (widget.isOwn)
          ActionButton(
            text: "Edit",
            icon: Icons.edit,
            onPressed: widget.handleEdit,
          ),

        if (widget.isAdmin)
          ActionButton(
            text: "Pin",
            icon: Icons.push_pin,
            highlight: widget.pinned,
            onPressed: widget.handlePin,
          ),
        
        ActionButton(
          text: "Show profile",
          icon: Icons.person,
          onPressed: () => navigateToPage(
            context, ProfileScreen(userId: widget.userId)),
        ),

        if (widget.isOwn || widget.isAdmin)
          ActionButton(
            text: "Delete",
            icon: Icons.delete,
            onPressed: _handleDelete
          ),
      ]),
    );
  }


  // NOTE: not used anymore
  // called when edit action is selected
  Future<void> _handleEdit() async {

    // asks for edited message (with dialog)
    final newContent = await showDialog<String>(
      context: context,
      builder: (context) => EditMessageDialog(initialText: widget.text),
    );
    if (newContent == null) return;
  }


  // called when delete to message is selected
  Future<void> _handleDelete() async {
    // TODO: ask confirmation (with dialog)

    try {
      await PocketBaseService().deleteMessage(widget.messageId);
    } catch (e) {
      if (mounted) snackBarText(context, 'Delete failed: ${e.toString()}');
    }
  }
}


// single option for context menu
class ActionButton {
  final String text;
  final IconData icon;
  final bool highlight;
  final VoidCallback? onPressed;

  const ActionButton({
    required this.text,
    required this.icon,
    this.highlight = false,
    this.onPressed,
  });
}


// menu with action buttons
class ActionButtonsMenu extends StatelessWidget {
  final List<ActionButton> actions;
  final VoidCallback? onSelection;

  const ActionButtonsMenu({
    super.key,
    required this.actions,
    this.onSelection,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.normal(context),
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppStyles.shadow(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(

        // builds one button for every action
        children: actions.map((action) =>
          Tooltip(
            message: action.text,
            child: IconButton(
              icon: Icon(action.icon, size: 18),
              style: action.highlight ? // accent style if highlighted
                AppStyles.btnAccent(context) : AppStyles.btnNormal(context),
              onPressed: () {
                onSelection!();
                action.onPressed!();
              },
            ),
          ),
        ).toList()
      ),
    );
  }
}
