
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/localize.dart';

import 'package:flutterchat/room/details.dart';
import 'package:flutterchat/chat/input.dart';
import 'package:flutterchat/chat/msg.dart';
import 'package:flutterchat/chat/preview.dart';
import 'package:flutterchat/chat/extras.dart';



// screen with chat history, and new message field
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}


class ChatScreenState extends State<ChatScreen> {

  // server connection and realtime handler
  final PocketBaseService pb = PocketBaseService();
  late final UnsubscribeFunc _unsubscribe;

  // controllers for message list view
  final ScrollController _scrollController = ScrollController();
  late ListObserverController _observerController;
  late ChatScrollObserver _chatObserver;

  // loaded messages
  // TODO: use device cache
  final List<Message> _messages = [];

  // messages arrived when viewing old ones
  int newMessages = 0;
  bool viewingLastMsg = true;
  
  // messages arrived when chat not shown
  // TODO: load from pocketbase on app open
  int unreadMessages = 3;

  // message pinned at top, if any
  Message? pinnedMessage;

  // message being edited, if any
  Message? editingMessage;

  // message being quoted (reply action), if any
  Message? replyingMessage;


  @override
  void initState() {
    super.initState();

    // loads messages and prepares server hooks
    _loadMessages();
    _setupRealtime();

    // configures scroller animation, disactivating position cache
    // this ensures proper scroll jump when messages are edited or removed
    _observerController = ListObserverController(controller: _scrollController)
      ..cacheJumpIndexOffset = false;

    // provides smart scrolling behaviour for messages
    _chatObserver = ChatScrollObserver(_observerController)

      // min scroll offset to disable auto-scroll on new messages
      ..fixedPositionOffset = 50;
  }

  @override
  void dispose() {
    _observerController.controller?.dispose();
    _unsubscribe();
    super.dispose();
  }


  // loads messages and shows them in the list view
  Future<void> _loadMessages() async {
    final messages = await pb.loadMessages();
    if (!mounted) return;
    setState(() {
      _messages.addAll(messages.reversed);
      searchPinnedMessage();
    });
  }


  // searches most recent pinned message, to show it on top of chat
  // TODO: allow multiple pinned messages, show the one pinned most recently
  void searchPinnedMessage() {
    for (var msg in _messages) {

      // skips deleted messages
      if (msg.justDeleted) continue;

      // finds the most recent pinned
      if (msg.pinned) {
        pinnedMessage = msg;
        return;
      }
    }
    pinnedMessage = null;
  }


  // sets up actions when something occurs with messages
  Future<void> _setupRealtime() async {
    _unsubscribe = await pb.client.collection('messages')
      .subscribe('*', (e) => _handleMessage(e.record, e.action), expand: 'user, replyTo.user');
  }


  // called on updates to some message
  void _handleMessage(RecordModel? msg, String action) {
    if (msg == null) return;

    switch (action) {
      case 'create':
        _chatObserver.standby(); // smart scrolling
        setState(() {
        
          // adds the new messages to the list
          _messages.insert(0, Message(msg));

          // updates count of new messages if needed
          if (!viewingLastMsg) newMessages++;
        });
        break;

      case 'update':
        final index = _messages.indexWhere((m) => m.id == msg.id);
        if (index == -1) return;

        // locks message scrolling
        _chatObserver.standby(isRemove: true);

        // updates message
        setState(() {
          _messages[index] = Message(msg);
          searchPinnedMessage();
        });

        break;

      case 'delete':
        final index = _messages.indexWhere((m) => m.id == msg.id);
        if (index == -1) return;

        // locks message scrolling
        _chatObserver.standby(isRemove: true);

        // sets message as just deleted
        setState(() {
          _messages[index].justDeleted = true;
          searchPinnedMessage();

          // deactivates reply or edit if message deleted
          if (replyingMessage?.id == msg.id) replyingMessage = null;
          if (editingMessage?.id  == msg.id) editingMessage = null;
        });
        break;

      default:
    }
  }


  // called when send button is pressed
  void _onSubmit(String text) {
    if (editingMessage != null) {
      _editMessage(editingMessage as Message, text);
    } else {
      _sendMessage(text, replyingMessage);
    }
    setState(() { replyingMessage = null; });
  }


  // sends a new message to the server
  Future<void> _sendMessage(String text, Message? replyingMessage) async {
    if (text.isEmpty) return;

    try {
      // sends message
      await PocketBaseService().sendMessage(text, replyingMessage);
      if (!mounted) return;

      // TODO: clear unread messages on server

      // scrolls to bottom, assuming that user read all new messages
      _scrollToMessageIndex(0);
      setState(() { unreadMessages = 0; });

    } catch (e) {
      if (mounted) snackBarText(context, 'Failed to send message: ${e.toString()}');
    }
  }


  // edits an existing message
  Future<void> _editMessage(Message message, String newText) async {
    try {
      await PocketBaseService().updateMessage(message.id, newText);
      if (mounted) setState(() { editingMessage = null; });
    } catch (e) {
      if (mounted) snackBarText(context, 'Edit failed: ${e.toString()}');
    }
  }


  // called when reply or edit message action is selected
  void _handleEdit (Message message) => setState(() { editingMessage  = message; });
  void _handleReply(Message message) => setState(() { replyingMessage = message; });


  // called when pin message action is selected
  Future<void> _handlePin(Message message, {bool unPin = false}) async {
    try {
      // prevents pinning message if some other is already pinned
      // TODO: implement multiple pinned messages
      if (pinnedMessage != null && unPin == false) {
        snackBarText(context, localize("chat.pin.multi"));
        return;
      }

      // toggles pinned state
      await PocketBaseService().pinMessage(message.id, !unPin);
      if (mounted) setState(searchPinnedMessage);
    } catch (e) {
      if (mounted) snackBarText(context, 'Pin/unpin failed: ${e.toString()}');
    }
  }


  // scrolls view to message
  void _scrollToMessage(Message? message) {
    if (message == null) return;

    // finds index of specified message
    final index = _messages.indexWhere((m) => m.id == message.id);

    // scrolls to specified message
    _scrollToMessageIndex(index);
  }


  // scrolls view to message with index
  void _scrollToMessageIndex(int index) {
    if (index == -1) return;

    _observerController.animateTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // topbar with title and logout button
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => navigateToPage(context, RoomDetailsScreen()),
          child: Text('La forza del lupo è il Branco'),
        ),
        actions: [

          // search button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => notImplemented(context),
          ),

          // prevents overlapping between bebug banner and last action
          debugBannerSpace(),
        ],
      ),

      body: Column(
        children: [

          // bar just below top bar (or message edit bar), for message reply
          if (pinnedMessage != null) _buildPinnedMessageBar(),

          // center area with messages
          Expanded(
            child: Stack(
              children: [
                _buildMessagesList(),

                // button to jump to last message
                if (!viewingLastMsg)
                  Positioned(
                    bottom: AppDimensions.L,
                    right: AppDimensions.L,
                    child: JumpToLastMessageButton(
                      newMessages: newMessages,
                      onPressed: () { _scrollToMessageIndex(0); },
                    ),
                  ),
              ],
            ),
          ),

          // bar just above bottom bar (or message edit bar), for message reply
          if (replyingMessage != null) _buildReplyingMessageBar(),

          // bar just above bottom bar, for message edit
          if (editingMessage != null) _buildEditingMessageBar(),

          // bottom bar with send message field
          Container(
            padding: EdgeInsets.all(2 * AppDimensions.S),

            // custom style to match
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              boxShadow: context.styles.basic.shadow(),
            ),
            child: ChatInputBar(
              editingMessage: editingMessage,
              onSubmit: _onSubmit,
            ),
          ),
        ],
      ),
    );
  }


  // top bar to show pinned message
  Widget _buildPinnedMessageBar() {
    return MessagePreviewBar(
      styleGroup: context.styles.accent,
      // leadingIcon: Icons.push_pin,
      preview: MessagePreview(
        title: "Pinned message by ${pinnedMessage?.username}",
        message: pinnedMessage as Message,
        styleGroup: context.styles.accent,
        onPressed: () { _scrollToMessage(pinnedMessage); },
      ),

      // only admins can pin/unpin
      onCancel: PocketBaseService().isAdmin ?
        () { _handlePin(pinnedMessage as Message, unPin: true); } : null,
    );
  }


  // bottom bar to show message being edited
  Widget _buildEditingMessageBar() {
    return MessagePreviewBar(
      leadingIcon: Icons.edit,
      preview: MessagePreview(
        title: "Edit message",
        message: editingMessage!,
        onPressed: () { _scrollToMessage(editingMessage); },
        styleGroup: context.styles.basic,
      ),
      onCancel: () { setState(() { editingMessage = null; }); },
    );
  }


  // bottom bar to show message being replied to
  Widget _buildReplyingMessageBar() {
    return MessagePreviewBar(
      leadingIcon: Icons.reply,
      preview: MessagePreview(
        title: "Reply to ${replyingMessage?.username}",
        message: replyingMessage!,
        onPressed: () { _scrollToMessage(replyingMessage); },
        styleGroup: context.styles.basic,
      ),
      onCancel: () { setState(() { replyingMessage = null; }); },
    );
  }


  // scrollable list of messages
  Widget _buildMessagesList() {
    return ListViewObserver(
      controller: _observerController,

      // called when scrolling
      onObserve: (resultModel) {
        setState(() {
          
          // detects if we are viewing old messages or not
          viewingLastMsg = _scrollController.offset <= _chatObserver.fixedPositionOffset;

          // decreases new messages counter, when scrolling to them in list view
          final index = resultModel.firstChild?.index;
          if (index != null) if (index < newMessages) newMessages = index;
        });
      },
      child: ListView.builder(
        reverse: true,
        controller: _scrollController,
        physics: ChatObserverClampingScrollPhysics(observer: _chatObserver),
        shrinkWrap: _chatObserver.isShrinkWrap,
        itemCount: _messages.length,

        // displays a message, and its other extras
        itemBuilder: (context, index) {
          
          // gets message and its date
          final message = _messages[index];
          final dateLocal = message.dateLocal;

          // gets previous message and checks if has different date
          final prev = _messages.elementAtOrNull(index + 1);
          final firstOfDay = (prev == null) || (prev.dateLocal != dateLocal);

          return Column(children: [

            // displays "unread messages" title over message
            if (index == unreadMessages - 1)
              UnreadMessagesTitle(count: unreadMessages),

            // displays date title over message, if first of the day
            if (firstOfDay)
              DateTitle(localDate: dateLocal),

            // displays message
            MessageBubble(
              msg: message,
              handlePin:      () => _handlePin(message, unPin: message.pinned),
              handleEdit:     () => _handleEdit(message),
              handleReply:    () => _handleReply(message),
              onReplyClicked: () => _scrollToMessage(message.repliedTo),
            ),
          ]);
        },
      ),
    );
  }

}
