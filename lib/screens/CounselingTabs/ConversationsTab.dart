import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';
import '../../sizeConfig.dart';

class ConversationsTab extends StatelessWidget {
  ConversationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var conversations = counselorprovider.conversations;
    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    Widget conversationBuilder(BuildContext ctx, int index) {
      return ListTile(
        leading: CircleAvatar(
          radius: SizeConfig.isTabletWidth ? 98 : 20.0,
          child: ClipOval(
            child: Image.network(
              conversations[index]['urlPath'],
              width: SizeConfig.isTabletWidth ? 120 : 90,
              height: SizeConfig.isTabletWidth ? 120 : 90,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(conversations[index]['name'], style: style),
        subtitle: Text(
          'Hello there say something',
          style: TextStyle(
            color: Theme.of(ctx).primaryColor,
            fontSize: SizeConfig.isTabletWidth ? 16 : 14,
          ),
        ),
      );
    }

    return conversations.isNotEmpty
        ? ListView.builder(
            itemBuilder: conversationBuilder,
            itemCount: conversations.length,
          )
        : Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child:
                  SpinKitSpinningLines(color: Theme.of(context).primaryColor),
            ),
          );
  }
}
