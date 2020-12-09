import 'package:flutter/foundation.dart';

import './user_model.dart';

class Message {
  final User sender;
  final DateTime timeReceived;
  final String text;
  final bool isLiked;
  final bool isRead;

  Message({
    @required this.sender,
    @required this.timeReceived,
    @required this.text,
    this.isLiked = false,
    this.isRead = false,
  });
}
