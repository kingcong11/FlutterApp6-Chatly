import 'dart:convert';

/* Packages */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* Screens */
import 'package:chatly/screens/thread_screen.dart';

/* Widgets */
import '../widgets/favorites_section.dart';
import '../widgets/shared/list_tile_skeleton.dart';

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
              height: contentHeight * .23,
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
                      .snapshots(),
                  builder: (_, chatsSnapshot) {
                    if (chatsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SingleChildScrollView(
                        child: ListStileSkeleton(),
                      );
                    } else if (chatsSnapshot.hasError) {
                      return Text('Error Screen');
                    } else {
                      final chatsDocs = chatsSnapshot.data.documents;

                      return ListView.builder(
                        itemCount: chatsDocs.length,
                        itemBuilder: (ctx, i) {
                          // print('participants:');
                          // print(chatsDocs[i]['participants']);
                          return ListTile(
                            key: ValueKey(chatsDocs[i].id),
                            leading: Icon(Icons.verified_user),
                            title: Text(chatsDocs[i].id),
                            onTap: () => Navigator.of(context).pushNamed(
                              ThreadScreen.routeName,
                              arguments: chatsDocs[i].id,
                            ),
                          );
                        },
                      );
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
