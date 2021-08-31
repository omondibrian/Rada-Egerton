import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';

class ConversationsTab extends StatelessWidget {
  ConversationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var conversations = counselorprovider.conversations;
    Widget conversationBuilder(BuildContext ctx, int index) {
      return ListTile(
        leading: CircleAvatar(
          radius: 5.0,
          child: Image.network(conversations[index]['urlPath']),
        ),
        title: Text(conversations[index]['name']),
        subtitle: Text('Hello there say something',
            style: TextStyle(color: Theme.of(ctx).primaryColor)),
      );
    }

    return conversations.isNotEmpty
        ? ListView.builder(
            itemBuilder: conversationBuilder,
            itemCount: conversations.length,
          )
        : Center(
            child: SizedBox(
                width: 80, height: 80, child: CircularProgressIndicator()));
  }
}
