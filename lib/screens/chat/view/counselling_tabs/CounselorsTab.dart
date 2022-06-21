import 'package:rada_egerton/loading_effect/shimmer.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';
import 'package:rada_egerton/resources/config.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/screens/chat/view/counselling_tabs/PeerCounselorsTab.dart';
import 'package:rada_egerton/sizeConfig.dart';
import 'package:rada_egerton/widgets/ratingBar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CounsellorsTab extends StatelessWidget {
  const CounsellorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counsellorprovider = Provider.of<CounsellorProvider>(context);
    final appProvider = Provider.of<RadaApplicationProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final counsellors = counsellorprovider.counsellors;

    Future<void> _refresh() async {
      counsellorprovider.getCounsellors();
    }

    Widget conselorsBuilder(BuildContext cxt, int index) {
      return GestureDetector(
        onTap: () {
          if (counsellors![index].user.id == appProvider.user!.id) {
            return null;
          }
          //TODO: route user
          // context.
        },
        child: Card(
          elevation: 0,
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: SizeConfig.isTabletWidth ? 40 : 20.0,
                    child: ClipOval(
                      child: CachedNetworkImage(
                          color: Colors.white,
                          imageUrl: GlobalConfig.imageUrl(
                              counsellors![index].user.profilePic),
                          imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                width: SizeConfig.isTabletWidth ? 120 : 90,
                                height: SizeConfig.isTabletWidth ? 120 : 90,
                              ),
                          placeholder: (context, url) =>
                              Image.asset("assets/user.png")),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Text(
                      counsellors[index].user.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Expertise : ',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontSize: 14)),
                    Text(
                      counsellors[index].expertise,
                    ),
                  ],
                ),
                Row(
                  children: [
                    ratingBar(rating: counsellors[index].rating, size: 20),
                  ],
                ),
              ])
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(),
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      displacement: 20.0,
      edgeOffset: 5.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: counsellors == null
            ? Shimmer(
                child: ListView(
                  children:
                      List.generate(4, (index) => placeHolderListTile(context)),
                ),
              )
            : counsellors.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("No counsellors available"),
                  )
                : ListView.builder(
                    itemBuilder: conselorsBuilder,
                    itemCount: counsellors.length,
                  ),
      ),
    );
  }
}
