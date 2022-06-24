import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/peer_counselors_tab.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';
import 'package:rada_egerton/presentation/widgets/ratingBar.dart';
import 'package:rada_egerton/resources/config.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CounsellorsTab extends StatelessWidget {
  const CounsellorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counsellorprovider = Provider.of<CounsellingProvider>(context);
    final counsellors = counsellorprovider.counsellors;

    Future<void> _refresh() async {
      await counsellorprovider.initCounsellors();
    }

    Widget conselorsBuilder(BuildContext cxt, int index) {
      return GestureDetector(
        onTap: () {
          if (counsellors[index].user.id == GlobalConfig.instance.user.id) {
            return;
          }
          context.pushNamed(
            AppRoutes.privateChat,
            params: {
              "recepientId": counsellors[index].user.id.toString(),
            },
          );
        },
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: SizeConfig.isTabletWidth ? 40 : 20.0,
                    child: ClipOval(
                      child: CachedNetworkImage(
                          color: Colors.white,
                          imageUrl:
                              imageUrl(counsellors[index].user.profilePic),
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
              const SizedBox(
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

        // ignore: curly_braces_in_flow_control_structures
        child: Builder(
          builder: (context) {
            if (counsellorprovider.counsellorStatus == ServiceStatus.loading) {
              return Shimmer(
                child: ListView(
                  children:
                      List.generate(4, (index) => placeHolderListTile(context)),
                ),
              );
            }
            if (counsellorprovider.counsellorStatus ==
                ServiceStatus.loadingFailure) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text("An error occurred"),
                    TextButton(
                      onPressed: () => _refresh(),
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            }
            if (counsellors.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8),
                child: Text("No counsellors available"),
              );
            }
            return ListView.builder(
              itemBuilder: conselorsBuilder,
              itemCount: counsellors.length,
            );
          },
        ),
      ),
    );
  }
}
