import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({
    Key key,
    @required this.chatId,
  }) : super(key: key);

  final String chatId;

  /* Builders */
  Widget _messageBubbleBuilder(
    String message,
    Key key, [
    double width,
    bool isMe = false,
  ]) {
    return Row(
      mainAxisAlignment: (isMe) ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          key: key,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13),
          margin: EdgeInsets.only(
            top: 2.5,
            bottom: 2.5,
          ),
          constraints: BoxConstraints(
            maxWidth: width * 0.75,
          ),
          decoration: BoxDecoration(
            color: (isMe) ? Color(0xFF5BC236) : Color(0xFFe5e5ea),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: (isMe) ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/$chatId/messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('List Tile Skeleton'),
            );
          } else if (streamSnapshot.hasError) {
            return Center(
              child: Text('Error Screen'),
            );
          } else {
            final messageDocuments = streamSnapshot.data.documents;
            bool isMe;
            // bool previous = false;

            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 10.0,
                  left: 10.0,
                  right: 10.0,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: messageDocuments.length,
                itemBuilder: (_, index) {
                  isMe = (messageDocuments[index]['userId'] == FirebaseAuth.instance.currentUser.uid);
                  return _messageBubbleBuilder(messageDocuments[index]['text'], ValueKey(messageDocuments[index].id), deviceSize.width, isMe);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
