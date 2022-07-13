import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/contacts_dto.dart';
import 'package:rada_egerton/data/services/news_location_service.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/peer_counselors_tab.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';
import 'package:rada_egerton/resources/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTab extends StatefulWidget {
  const ContactTab({Key? key}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  List<Contact>? _contactList;
  NewsAndLocationServiceProvider service = NewsAndLocationServiceProvider();
  // late final Uri _defaultAppUrl;

  // void _launchDefaultApp() async {
  //   if (!await launchUrl(_defaultAppUrl)) {
  //     throw 'Could not launch url : $_defaultAppUrl';
  //   }
  // }

  Future<void> init() async {
    final result = await service.getContacts(
      retryLog: (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "An error occured, retying...",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
    result.fold(
      (l) => setState(() {
        _contactList = l;
      }),
      (err) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            err.message,
            style: TextStyle(color: Colors.red[700]),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: init,
      child: _contactList == null
          ? Shimmer(
              child: ListView(
                children: List.generate(
                  4,
                  (index) => const TileLoader(),
                ),
              ),
            )
          : ListView.builder(
              itemCount: _contactList!.length,
              itemBuilder: (BuildContext ctx, int index) =>
                  contactCard(_contactList![index]),
            ),
    );
  }

  Widget contactCard(Contact contact) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => Container(
                  decoration: BoxDecoration(
                    border: const Border(
                      top: BorderSide(
                        color: Palette.primary,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(
                                  Uri(scheme: 'tel', path: contact.phone),
                                );
                                //todo: set url launcher to phone screen
                                //todo: with respective number on the keypad
                              },
                              child: const Icon(
                                Icons.phone,
                                color: Palette.primary,
                                size: 50.0,
                              ),
                            ),
                            Text(
                              'Phone',
                              style: Theme.of(context).textTheme.headline6,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(
                                  Uri(
                                      scheme: 'mailto',
                                      path: contact.email,
                                      queryParameters: {
                                        'subject': 'Rada Help',
                                        'body': 'Include your message here.'
                                      }),
                                );
                                //todo: set url launcher to default email app
                                //todo: with respective details populated
                              },
                              child: const Icon(
                                Icons.email_rounded,
                                color: Palette.primary,
                                size: 50.0,
                              ),
                            ),
                            Text(
                              'Mail',
                              style: Theme.of(context).textTheme.headline6,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
      },
      child: Card(
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
                  Text(contact.name,
                      style: Theme.of(context).textTheme.subtitle1),
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
                  Text(contact.phone,
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
                  Text(contact.email,
                      style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
