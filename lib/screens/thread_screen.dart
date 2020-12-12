/* Packages */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/thread';

  /* Builders */
  Widget _appbarBuilder(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        'Sender name',
        style: TextStyle(fontSize: 24),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  /* Getters */
  double _computeMainContentHeight(
    MediaQueryData mediaQueryData,
    AppBar appbar,
  ) {
    return mediaQueryData.size.height -
        (appbar.preferredSize.height + mediaQueryData.padding.top);
  }

  @override
  Widget build(BuildContext context) {
    final appbar = _appbarBuilder(context);
    return Scaffold(
      appBar: appbar,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats/m9dxXbwyVQQKc8gi4cSW/messages').snapshots(),
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
            final documents = streamSnapshot.data.documents;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (_, index) {
                return Text(documents[index]['text']);
              },
            );
          }
        },
      ),
    );
  }
}
