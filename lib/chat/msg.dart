import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/localize.dart';

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
  late final DateTime createdUTC;

  // gets data from message record
  Message(RecordModel record) {
    final user = record.get<RecordModel>("expand.user");

    id       = record.id;
    text     = record.get<String?>('message') ?? '';
    pinned   = record.get<bool?>('pinned') ?? false;
    userId   = user.id;
    username = user.get<String?>('username') ?? 'Unknown';
    isOwn    = userId == PocketBaseService().userId;
    createdUTC = DateTime.parse(record.get<String>("created"));
  }

  // gets date in local timezone
  DateTime get dateLocal => createdUTC.utcToAppTz.date;
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

  DateTime  get createdUTC => msg.createdUTC;

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

    return MouseRegion(
      onExit: _isDesktop ? (_) { setState(() => _showActions = false); } : null,
      child: GestureDetector(
        
        // shows context menu when long-tapping or right-click the MessageBubble
        onSecondaryTap: () => setState(toggleShowActions),
        onLongPress:    () => setState(toggleShowActions),

        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              // own messages on right, others' on left
              alignment: widget.isOwn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(

                // message width: 90% of parent
                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.9),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),

                // message group: avatar (only other users) + bubble
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (!widget.isOwn)
                      _buildAvatar(context),

                    Expanded(child: Container(
                      alignment: widget.isOwn ? Alignment.centerRight : Alignment.centerLeft,
                      child: _buildBubble(context)
                    )),
                  ],
                ),
              ),
            ),

            // shows context menu overlay
            if (_showActions) _buildContextMenu(context),
          ],
        ),
      ),
    );
  }


  // builds user avatar for message
  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(

      // background depending on user
      backgroundColor: widget.isOwn ?
        AppColors.accent(context) : AppColors.normal(context),
      
      // first letter of username
      child: Text(
        widget.msg.username[0].toUpperCase(),
        // style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }


  // builds the bubble
  Widget _buildBubble(BuildContext context) {

    // color for username (based on username)
    final usernameColor = widget.isOwn ?
      AppColors.text(context) : widget.username.generateColor();

    // style for message bubble
    final bubbleStyle = widget.isOwn ?
      AppStyles.boxAccent(context) : AppStyles.boxNormal(context);

    return Container(
      decoration: bubbleStyle,
      padding: const EdgeInsets.all(12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // username with generated color (only for others' message)
          if (!widget.isOwn)
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
          parseLinks(widget.text, color: AppColors.text(context)),
          const SizedBox(height: 4),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              // timestamp
              Text(
                widget.createdUTC.utcToAppTz.formatLocalized(DateFormat.Hm),
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
    );
  }


  // context menu for messages
  Widget _buildContextMenu(BuildContext context) {
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
                onSelection?.call();
                action.onPressed?.call();
              },
            ),
          ),
        ).toList()
      ),
    );
  }
}
