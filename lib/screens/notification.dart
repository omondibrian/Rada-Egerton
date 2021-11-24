import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/utils/timeAgo.dart';

class NotificationDataTransfer {
  final String imageSrc;
  final String title;
  final String message;
  final DateTime timeCreated;
  //TODO: date formating
  //TODO: fetch notification from server
  NotificationDataTransfer(
      this.imageSrc, this.title, this.message, this.timeCreated);
  factory NotificationDataTransfer.fromjson(Map<String, dynamic> data) {
    return NotificationDataTransfer(
        data["imageSrc"], data["title"], data["message"], DateTime.now());
  }
}

Future<void> _refreshChat() async {
  //TODO : function call to refresh notification data
  await Future.delayed(Duration(milliseconds: 1000));
}

class UserNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Notification',
        style: Theme.of(context)
            .textTheme
            .headline1
            ?.copyWith(color: Colors.white),
      )),
      body: RefreshIndicator(
        onRefresh: () => _refreshChat(),
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        displacement: 20.0,
        edgeOffset: 5.0,
        child: ListView(
          children: notificationItems
              .map((item) => notificationCard(
                  NotificationDataTransfer.fromjson(item), context))
              .toList(),
        ),
      ),
    );
  }

  Widget notificationCard(
      NotificationDataTransfer notification, BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: notification.imageSrc,
                  placeholder: (context, url) => SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    height: 50,
                    width: 50,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      notification.message,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ],
            ),
            Text(
              TimeAgo.timeAgoSinceDate(notification.timeCreated),
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> notificationItems = [
  {
    "imageSrc":
        'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    "title": "Anouncement",
    "timeCreated": "12/12/2021",
    "message": "This is rada test notification"
  },
  {
    "imageSrc":
        'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    "title": "Event",
    "timeCreated": "12/12/2021",
    "message": "This is rada test notification"
  },
];
