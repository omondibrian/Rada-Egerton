import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/locationDto.dart';
import 'package:rada_egerton/services/NewsAndLocation/main.dart';

class ContactTab extends StatefulWidget {
  @override
  _ContactTabState createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  List<Contact> _contactList = [];
  NewsAndLocationServiceProvider service = NewsAndLocationServiceProvider();
  Future<void> init() async {
    final result = await service.getContacts();
    result.fold(
        (l) => setState(() {
              _contactList = l;
            }),
        (r) => print(r));
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this._contactList.length,
        itemBuilder: (BuildContext ctx, int index) =>
            contactCard(this._contactList[index]));
  }

  Widget contactCard(Contact contact) {
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
                Text(contact.name,
                    style: Theme.of(context).textTheme.subtitle1),
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
                Text(contact.phone,
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
                Text(contact.email,
                    style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
