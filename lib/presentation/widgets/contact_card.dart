import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String title;
  final String phoneNumber;
  final String email;
  final String location;
  const ContactCard(
      {Key? key,
      required this.title,
      required this.phoneNumber,
      required this.email,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColorLight,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(phoneNumber,
                    style: Theme.of(context).textTheme.subtitle2)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColorLight,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(email, style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColorLight,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(location,
                    style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
