import 'package:flutter/material.dart';
import 'package:rada_egerton/widgets/ContactCard.dart';

class ContactTab extends StatelessWidget {
  ContactTab({Key? key}) : super(key: key);
  //TODO:fetch actual contact list from backend api
  
  final List _contactList = [
    {
      'title': 'Main Campus',
      'phoneNumber': '+25476365537',
      'email': 'egerton@gmail.com',
      'location': 'Njoro'
    },
    {
      'title': 'Nakuru Campus',
      'phoneNumber': '+25476365537',
      'email': 'egerton@gmail.com',
      'location': 'Nakuru'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this._contactList.length,
      itemBuilder: (BuildContext ctx, int index) => ContactCard(
        title: this._contactList[index]['title'],
        phoneNumber: this._contactList[index]['phoneNumber'],
        email: this._contactList[index]['email'],
        location: this._contactList[index]['location'],
      ),
    );
  }
}
