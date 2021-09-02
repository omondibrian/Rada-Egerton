import 'package:flutter/material.dart';
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

class UserNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Notification',
        style: Theme.of(context).textTheme.headline1,
      )),
      body: ListView(
        children: notificationItems
            .map((item) => notificationCard(
                NotificationDataTransfer.fromjson(item), context))
            .toList(),
      ),
    );
  }

  Widget notificationCard(
      NotificationDataTransfer notification, BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(notification.imageSrc,
                      width: 50, height: 50, fit: BoxFit.cover),
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
