import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageComposer extends StatefulWidget {
  const MessageComposer({
    Key key,
    @required this.chatId,
  }) : super(key: key);

  final String chatId;

  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  /* Methods */
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chats/${widget.chatId}/messages').add({
      'text': _enteredMessage,
      'createdAt': DateTime.now(),
      'userId': FirebaseAuth.instance.currentUser.uid,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey[800],
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 20,
        right: 5,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.smile),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Container(
                      // color: Colors.red,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Aa',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _enteredMessage = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            child: GestureDetector(
              child: Icon(
                (_enteredMessage.trim().isEmpty) ? Icons.favorite : Icons.send,
                size: 35,
                color: (_enteredMessage.trim().isEmpty)
                    ? Colors.red
                    : Colors.teal[400],
              ),
              onTap: (_enteredMessage.trim().isEmpty) ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
