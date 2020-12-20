/* Packages */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* Helpers */
import 'package:chatly/helpers/database.dart';

/* Screens */
import './thread_screen.dart';
import './search_screen.dart';

/* Widgets */
import '../widgets/favorites_section.dart';

class HomePageScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/homepage';

  final double contentHeight;
  final double contentWidth;

  HomePageScreen({
    @required this.contentHeight,
    @required this.contentWidth,
  });

  @override
  Widget build(BuildContext context) {
    var db = new DatabaseHelper();

    return Container(
      height: contentHeight,
      width: contentWidth,
      color: Theme.of(context).primaryColor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: contentHeight * .21,
              padding: const EdgeInsets.only(
                top: 14.0,
              ),
              child: FavoritesSection(),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where(
                        'participants',
                        arrayContains: FirebaseAuth.instance.currentUser.uid,
                      )
                      .orderBy('lastUpdate', descending: true)
                      .snapshots(),
                  builder: (_, chatsSnapshot) {
                    if (chatsSnapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (chatsSnapshot.hasError) {
                      print(chatsSnapshot.error);
                      return Text('Error Screen');
                    } else {
                      final chatsDocs = chatsSnapshot.data.documents;

                      if (chatsDocs.length > 0) {
                        return ListView.builder(
                          itemCount: chatsDocs.length,
                          itemBuilder: (ctx, i) {
                            var participants = chatsDocs[i]['participants'] as List;
                            var partnerIndex = participants.indexWhere( (userId) => userId != FirebaseAuth.instance.currentUser.uid);

                            return FutureBuilder(
                              future: db.getUserInfo(participants[partnerIndex]),
                              builder: (ctx, futureSnapshot) {
                                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                                  return Container();
                                } else {
                                  var userInfo = futureSnapshot.data as Map<String, dynamic>;
                                  return MessageTile(
                                    chatsId: chatsDocs[i].id,
                                    userInfo: userInfo,
                                    participants: participants,
                                    partnerIndex: partnerIndex,
                                    futureSnapshot: futureSnapshot,
                                  );
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Container(
                                alignment: Alignment.center,
                                width: 340,
                                child: Text(
                                  'Start a wonderful conversation with your friends!',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 210,
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: 5,
                                      left: 80,
                                      child: Image.asset(
                                        'assets/images/Avatars1.png',
                                        scale: 3.5,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 75,
                                      child: Image.asset(
                                        'assets/images/Avatars2.png',
                                        scale: 3.5,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      child: Image.asset(
                                        'assets/images/Avatars3.png',
                                        scale: 3.2,
                                      ),
                                    ),
                                    Positioned(
                                      left: 100,
                                      bottom: 0,
                                      child: Image.asset(
                                        'assets/images/Avatars5.png',
                                        scale: 3.2,
                                      ),
                                    ),
                                    Positioned(
                                      right: 95,
                                      bottom: 0,
                                      child: Image.asset(
                                        'assets/images/Avatars4.png',
                                        scale: 3.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: 160,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: LinearGradient(
                                      colors: [Colors.blue, Colors.teal],
                                    ),
                                  ),
                                  child: Text(
                                    'Find friends',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => SearchScreen(),
                                  ));
                                },
                              )
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatefulWidget {
  const MessageTile({
    Key key,
    @required this.chatsId,
    @required this.userInfo,
    @required this.participants,
    @required this.partnerIndex,
    @required this.futureSnapshot,
  }) : super(key: key);

  final String chatsId;
  final Map<String, dynamic> userInfo;
  final List participants;
  final int partnerIndex;
  final AsyncSnapshot<dynamic> futureSnapshot;

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/${widget.chatsId}/messages')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .snapshots(),
        builder: (_, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            var messages = streamSnapshot.data.documents;
            var latestMessage = messages[0];
            var isHighlight = (latestMessage['isRead'] == false &&
                latestMessage['userId'] !=
                    FirebaseAuth.instance.currentUser.uid);

            return ListTile(
              key: ValueKey(widget.chatsId),
              leading: CircleAvatar(
                backgroundImage:
                    (widget.userInfo.containsKey('profileImageUrl'))
                        ? NetworkImage(
                            widget.futureSnapshot.data['profileImageUrl'],
                          )
                        : AssetImage(
                            'assets/images/no-user.png',
                          ),
              ),
              title: Text(
                widget.futureSnapshot.data['username'],
                style: TextStyle(
                  fontSize: isHighlight ? 20 : 18,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                  color: isHighlight ? Colors.black87 : Colors.grey[800],
                ),
              ),
              subtitle: Text(
                latestMessage['text'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                  color: isHighlight ? Colors.black87 : Colors.grey,
                ),
              ),
              trailing: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isHighlight ? Colors.blue : Colors.transparent,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  ThreadScreen.routeName,
                  arguments: {
                    'chatId': widget.chatsId,
                    'participantUsername':
                        widget.futureSnapshot.data['username'],
                    'participantUid': widget.participants[widget.partnerIndex],
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
