import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/localize.dart';
import 'package:flutterchat/chat/msg.dart';


// bottom input bar of the chat, used for both new and edit message
class ChatInputBar extends StatefulWidget {
  final Message? editingMessage;
  final ValueSetter<String> onSubmit;

  const ChatInputBar({
    super.key,
    required this.editingMessage,
    required this.onSubmit,
  });

  // is the user editing a message?
  bool get isEditing => editingMessage != null;

  @override
  State<ChatInputBar> createState() => ChatInputBarState();
}


class ChatInputBarState extends State<ChatInputBar> {

  // used to hide input placeholder on focus
  bool _hasFocus = false;

  // used to refocus input after message sent
  final FocusNode _focusNode = FocusNode();

  // controllers for new message/edit message field
  // we use 2 controllers so that the 2 actions are independent
  // this ensures don't loose new message draft, while editing another message
  final _newMessageController  = TextEditingController();
  final _editMessageController = TextEditingController();

  TextEditingController get _currentController =>
    widget.isEditing ? _editMessageController : _newMessageController;


  // displays bottom bar with new message field
  @override
  Widget build(BuildContext context) {

    // prepares the edit field, filling the original message to edit
    _editMessageController.text = widget.editingMessage?.text ?? "";

    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        // attach button
        IconButton(
          iconSize: 32,
          onPressed: () => notImplemented(context),
          icon: Icon(Icons.attach_file),
          color: context.styles.basic.normalTextColor,
        ),

        // message input
        Expanded(
          child: CallbackShortcuts(
            bindings: {
              // detects ctrl/alt/shift + enter to go to new line
              const SingleActivator(LogicalKeyboardKey.enter, control: true): _newLine,
              const SingleActivator(LogicalKeyboardKey.enter, alt:     true): _newLine,
              const SingleActivator(LogicalKeyboardKey.enter, shift:   true): _newLine,
            },
            child: Focus(
              onFocusChange: (hasFocus) { setState(() { _hasFocus = hasFocus; }); },
              child: TextField(
                // autofocus: true,
                focusNode: _focusNode,
                controller: _currentController,

                // hint shown only when field not focused
                decoration: InputDecoration(
                  hintText: _hasFocus ? '' : localize("chat.input.hint"),

                  // rounded sides
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.L),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.M,
                    vertical: AppDimensions.M,
                  ),
                ),

                minLines: 1, // default height: single line
                maxLines: 8, // expands to multiline, without exaggeration
                onSubmitted: _onSubmit,
                textInputAction: TextInputAction.send,
              ),
            ),
          ),
        ),

        // send message (or confirm edit) icon
        IconButton(
          iconSize: 32,
          style: context.styles.accent.btn(),
          icon: Icon(widget.isEditing ? Icons.done : Icons.send),
          onPressed: () => _onSubmit(_currentController.text),
        ),
      ],
    );
  }


  // called on input submit
  // sends message, clears input, refocus it to write other messages
  void _onSubmit(String text) {
    widget.onSubmit(text.trim());
    _currentController.clear();
    _focusNode.requestFocus();
  }


  // adds newline to message, called on Ctrl/Shift/Alt+Enter
  void _newLine() { _currentController.text += "\n"; }
}


// NOTE: this is not used anymore, but may be useful in the future!

// a little dialog box to edit the original message
class EditMessageDialog extends StatelessWidget {
  final String initialText;

  const EditMessageDialog({super.key, required this.initialText});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialText);
    final styleGroup = context.styles.accent;

    return AlertDialog(
      title: const Text('Edit Message'),
      backgroundColor: styleGroup.backgroundColor,
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: AppDimensions.radius
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: styleGroup.btn(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text),
          style: styleGroup.btn(),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
