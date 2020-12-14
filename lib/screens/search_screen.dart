import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helpers/database.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  final DatabaseHelper db = new DatabaseHelper();

  QuerySnapshot searchSnapshot;

  Widget searchResultBuilder() {
    if (searchSnapshot == null) {
      return Center(
        child: Text('Search for someone'),
      );
    } else if (searchSnapshot != null &&
        searchController.text.isNotEmpty &&
        searchSnapshot.docs.length == 0) {
      return Center(
        child: Text('No result for "${searchController.text}"'),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 5),
        itemCount: searchSnapshot.docs.length,
        itemBuilder: (ctx, index) {
          return SearchResultTile(
            username: searchSnapshot.docs[index].data()['username'],
            email: searchSnapshot.docs[index].data()['email'],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          color: Colors.white,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search user by username',
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () async {
              if (searchController.text.isNotEmpty) {
                final result = await db.searchUsername(searchController.text);
                setState(() {
                  searchSnapshot = result;
                });
                // print(result.docs.length);
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.green,
                child: searchResultBuilder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultTile extends StatelessWidget {
  final String username;
  final String email;

  SearchResultTile({
    @required this.email,
    @required this.username,
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
              Text(username),
              Text(email),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Message',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
