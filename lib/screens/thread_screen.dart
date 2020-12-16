/* Packages */
import 'package:chatly/helpers/database.dart';
import 'package:flutter/material.dart';

/* Widgets */
import '../widgets/thread/message_composer.dart';
import '../widgets/thread/messages.dart';

class ThreadScreen extends StatefulWidget {
  /* Properties */
  static const routeName = '/thread';

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  /* Properties */
  var _isInitialized = false;
  String _chatId;
  String _partnerUsername;
  String _participantUid;
  DatabaseHelper db = DatabaseHelper();

  /* Methods */
  void _setChatId(String newChatId) {
    setState(() {
      _chatId = newChatId;
    });
  }

  void _markMessagesAsRead(String chatId, String userUid) async {
    try {
      await db.markMessagesAsRead(chatId, userUid);
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    /* I use to have this work around because I cant place the initialization of chatId in the build method (NewChat from search screen)
    because  if I do so, by the time that chatId is reevaluated if it is null or not. chatId will be always null since I initialize it 
    by getting data from the modal route so even if the screen rebuilds chatId will be reinitialized by modalroute so I make sure that
    initialization from modal route only happens once */
    if (!_isInitialized) {
      final arguments =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _chatId = arguments['chatId'];
      _participantUid = arguments['participantUid'];
      _partnerUsername = arguments['participantUsername'];
      if (_chatId != null) {
        _markMessagesAsRead(_chatId, _participantUid);
      }
    }

    _isInitialized = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appbar = _appbarBuilder(context, _partnerUsername);
    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: (_chatId == null)
                  ? Center(
                      child: Text('Into message'),
                    )
                  : Messages(chatId: _chatId),
            ),
            MessageComposer(
                chatId: _chatId,
                setChatIdHandler: _setChatId,
                messageReceiverUid: _participantUid),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  /* Builders */
  Widget _appbarBuilder(BuildContext context, String username) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        username,
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            size: 25,
          ),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
      elevation: 0,
    );
  }

  /* Getters */
  double _computeMainContentHeight(
      MediaQueryData mediaQueryData, AppBar appbar) {
    return mediaQueryData.size.height -
        (appbar.preferredSize.height + mediaQueryData.padding.top);
  }
}
