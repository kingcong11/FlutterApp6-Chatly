/* Packages */
import 'package:flutter/material.dart';

/* Widgets */
import '../widgets/thread/message_composer.dart';
import '../widgets/thread/messages.dart';

class ThreadScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/thread';

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
  double _computeMainContentHeight(MediaQueryData mediaQueryData, AppBar appbar) {
    return mediaQueryData.size.height -
        (appbar.preferredSize.height + mediaQueryData.padding.top);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final chatId = arguments['chatId'];
    final partnerUsername = arguments['participantUsername'];

    final appbar = _appbarBuilder(context, partnerUsername);
    return Scaffold(
        appBar: appbar,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Messages(chatId: chatId),
              ),
              MessageComposer(chatId: chatId),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor);
  }
}
