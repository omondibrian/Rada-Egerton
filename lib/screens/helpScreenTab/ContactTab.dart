import 'package:flutter/material.dart';
import 'package:rada_egerton/widgets/ContactCard.dart';
import 'package:rada_egerton/entities/ContactsDto.dart';
import 'package:rada_egerton/services/NewsAndLocation/main.dart';

// ignore: must_be_immutable
class ContactTab extends StatelessWidget {

 late  ContactsDto _contactList ;

  ContactTab({Key? key}) : super(key: key){
      initContacts();
  }

initContacts() async {
  NewsAndLocationServiceProvider contactsProvider = NewsAndLocationServiceProvider();
 var result = await contactsProvider.fetchContacts();
 result!.fold((contacts) => this._contactList = contacts, (r) => print('error = $r'));
}
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this._contactList.contacts.length,
      itemBuilder: (BuildContext ctx, int index) => ContactCard(
        title: this._contactList.contacts[index].name,
        phoneNumber: this._contactList.contacts[index].phone,
        email: this._contactList.contacts[index].email,
        location: this._contactList.contacts[index].universityId,
      ),
    );
  }
}
