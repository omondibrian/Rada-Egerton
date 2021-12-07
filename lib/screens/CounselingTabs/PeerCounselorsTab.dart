import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/counselors.provider.dart';
import 'package:rada_egerton/services/constants.dart';

import '../../sizeConfig.dart';

class PeerCounselorsTab extends StatelessWidget {
  const PeerCounselorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var counselors = counselorprovider.peerCounselors;

    Future<void> _refresh() async {
      counselorprovider.getPeerCounsellors();
    }

    Widget peerCounsellorBuilder(BuildContext cxt, int index) {
      return Card(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: SizeConfig.isTabletWidth ? 40 : 20.0,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          "$BASE_URL/api/v1/uploads/${counselors[index].profilePic}",
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
                      placeholder: (context, url) => CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
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
                    counselors[index].name,
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Expertise : '),
                  Text(
                    counselors[index].expertise,
                  ),
                ],
              ),
            ])
          ],
        ),
      );
    }

    return counselorprovider.peerCouselorsLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : RefreshIndicator(
            onRefresh: () => _refresh(),
            backgroundColor: Theme.of(context).primaryColor,
            color: Colors.white,
            displacement: 20.0,
            edgeOffset: 5.0,
            child: counselors.isNotEmpty
                ? ListView.builder(
                    itemBuilder: peerCounsellorBuilder,
                    itemCount: counselors.length,
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No peer couselor available"),
                  ),
          );
  }
}
