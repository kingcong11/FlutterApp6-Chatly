import 'package:flutter/material.dart';

class Contact {
  final String userId;
  final String username;
  final String emailAddress;
  final isFavorite;

  Contact({
    @required this.userId,
    @required this.username,
    @required this.emailAddress,
    this.isFavorite = false,
  });
}

class Contacts with ChangeNotifier {

  List<Contact> _contacts = [];

  List<Contact> get getAllContacts {
    return [..._contacts];
  }

}
