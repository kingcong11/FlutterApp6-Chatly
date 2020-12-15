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
                if (!(list[index].id ==
                    FirebaseAuth.instance.currentUser.uid)) {
                  return SearchResultTile(
                    userId: list[index].id,
                    username: list[index]['username'],
                    email: list[index]['email'],
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
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.search,
          //     size: 30,
          //   ),
          //   onPressed: () async {
          //     if (searchController.text.isNotEmpty) {
          //       final result = await db.searchUsername(searchController.text);
          //       setState(() {
          //         searchSnapshot = result;
          //       });
          //       // print(result.docs.length);
          //     }
          //   },
          //   splashColor: Colors.transparent,
          //   highlightColor: Colors.transparent,
          // ),
        ],
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

  SearchResultTile({
    @required this.email,
    @required this.username,
    @required this.userId,
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
