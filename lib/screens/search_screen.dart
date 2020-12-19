import 'package:chatly/screens/thread_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helpers/database.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  final DatabaseHelper db = new DatabaseHelper();

  Widget searchResultBuilder(DatabaseHelper db) {
    return FutureBuilder(
      future: db.searchUsername(_searchQuery),
      builder: (_, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var list = futureSnapshot.data.documents as List;

          if (list.isEmpty && _searchQuery.isNotEmpty) {
            return Center(
              child: Text('No result for "$_searchQuery"'),
            );
          } else if (list.isEmpty && _searchQuery.isEmpty) {
            return Center(
              child: Text('Search for someone.'),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: list.length,
              itemBuilder: (ctx, index) {
                if (!(list[index].id == FirebaseAuth.instance.currentUser.uid)) {

                  // print

                  // var asMapHolder = list[index] as Map<String, dynamic>;

                  return SearchResultTile(
                    userId: list[index].id,
                    username: list[index]['username'],
                    email: list[index]['email'],
                    // hasProfileImage: asMapHolder.containsKey('profileImageUrl'),
                    // imageUrl: asMapHolder.containsKey('profileImageUrl') ? list[index]['profileImageUrl'] : 'assets/images/no-user.png',

                  );
                }
                return Container();
              },
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          color: Colors.white,
          width: 280,
          child: TextField(
            controller: searchController,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'Search user by username',
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: searchResultBuilder(db),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultTile extends StatelessWidget {
  final String userId;
  final String username;
  final String email;
  // final bool hasProfileImage;
  // final String imageUrl;


  SearchResultTile({
    @required this.email,
    @required this.username,
    @required this.userId,
    // @required this.hasProfileImage,
    // @required this.imageUrl
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(25),
            ),
            child: GestureDetector(
              child: Text(
                'Message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).popAndPushNamed(
                  ThreadScreen.routeName,
                  arguments: {
                    'chatId': null,
                    'participantUid': userId,
                    'participantUsername': username,
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
