
import 'package:flutter/material.dart';
import 'package:flutterchat/room/details.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/user/auth.dart';
import 'package:flutterchat/chat/input.dart';
import 'package:flutterchat/chat/msg.dart';
import 'package:flutterchat/chat/extras.dart';



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
  final List<RecordModel> _messages = [];

  // messages arrived when viewing old ones
  int newMessages = 0;
  bool viewingLastMsg = false;
  
  // messages arrived when chat not shown
  // TODO: load from pocketbase on app open
  int unreadMessages = 3;


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
      ..fixedPositionOffset = 5

      // not clear why... but this is needed to make smart scroll work...
      ..toRebuildScrollViewCallback = () { setState(() {}); };

  }

  @override
  void dispose() {
    _observerController.controller?.dispose();
    _unsubscribe();
    super.dispose();
  }


  // loads messages and shoes them in the list view
  Future<void> _loadMessages() async {
    final messages = await pb.loadMessages();
    if (!mounted) return;
    setState(() => _messages.addAll(messages.reversed));
  } 


  // sets up actions when something occurs with messages
  Future<void> _setupRealtime() async {
    _unsubscribe = await pb.client.collection('messages')
      .subscribe('*', (e) => _handleMessage(e.record, e.action), expand: 'user');
  }


  // called on updates to some message
  void _handleMessage(RecordModel? msg, String action) {
    if (msg == null) return;

    switch (action) {
      case 'create':
        _chatObserver.standby(); // smart scrolling
        setState(() {
        
          // adds the new messages to the list
          _messages.insert(0, msg);

          // updates count of new messages if needed
          if (!viewingLastMsg) newMessages++;
        });
        break;

      case 'update':
        final index = _messages.indexWhere((m) => m.id == msg.id);
        if (index == -1) return;
        setState(() => _messages[index] = msg);
        break;

      case 'delete':
        _chatObserver.standby(isRemove: true); // locks message scrolling
        setState(() => _messages.removeWhere((m) => m.id == msg.id));
        break;

      default:
    }
  }


  // scrolls view to message
  void _scrollToMessage(String messageId) {

    // finds index of specified message
    final index = _messages.indexWhere((m) => m.id == messageId);
    
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


  // logs user out, returning to login page
  Future<void> _logout() async {
    pb.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // topbar with title and logout button
      appBar: AppBar(
        title: TextButton(
          onPressed: () => navigateToPage(context, RoomDetailsScreen()),
          child: const Text('La forza del lupo è il Branco'),
        ),
        actions: [

          // test button to scroll
          TextButton(
            onPressed: () => _scrollToMessage("80my166t2465hf9"),
            child: const Text("Scroll to \"Gasp\""),
          ),
          TextButton(
            onPressed: () => _scrollToMessage("5mn4ozdmry3z1hq"),
            child: const Text("Scroll to \"daje\""),
          ),

          // logout button
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      body: Column(
        children: [

          // center area with messages
          Expanded(
            child: Stack(
              children: [
                _buildMessagesList(),

                // button to jump to last message
                if (!viewingLastMsg)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: JumpToLastMessageButton(
                      newMessages: newMessages,
                      onPressed: () { _scrollToMessageIndex(0); },
                    ),
                  ),
              ],
            ),
          ),

          // bottom bar with send message field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChatInputBar(onMessageSent: () {

              // scrolls to bottom, assuming that user read all new messages
              _scrollToMessageIndex(0);
              setState(() { unreadMessages = 0; });
            }),
          ),
        ],
      ),
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
          final date = getMessageDate(message);

          // gets previous message and its date
          final prevMessage = _messages.elementAtOrNull(index + 1);
          final prevMessageDate = getMessageDateOrNull(prevMessage);

          return Column(children: [

            // displays "unread messages" title over message
            if (index == unreadMessages - 1)
              UnreadMessagesTitle(count: unreadMessages),

            // displays date title over message, if first of the day
            if (date != prevMessageDate)
              DateTitle(date: date),

            // displays message
            MessageBubble.fromModel(message),
          ]);
        },
      ),
    );
  }


  // TODO: move to message bubble
  // gets the date of a message
  DateTime getMessageDate(RecordModel message) {
    final timestamp = DateTime.parse(message.get<String>("created"));
    return DateTime(timestamp.year, timestamp.month, timestamp.day);
  }

  DateTime? getMessageDateOrNull(RecordModel? message) {
    if (message == null) return null;
    return getMessageDate(message);
  }

}
