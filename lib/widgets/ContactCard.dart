import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String title;
  final String phoneNumber;
  final String email;
  final String location;
  ContactCard(
      {Key? key,
      required this.title,
      required this.phoneNumber,
      required this.email,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(this.title, style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.phone,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(this.phoneNumber,
                    style: Theme.of(context).textTheme.subtitle2)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Icon(
                  Icons.email,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(this.email, style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(this.location,
                    style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
