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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(this.title),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.phone,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(this.phoneNumber),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.email,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(this.email),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.pin_drop_outlined,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(this.email),
            ],
          ),
        ],
      ),
    );
  }
}
