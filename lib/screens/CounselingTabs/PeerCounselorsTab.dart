import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    counselorprovider.getPeerCounsellors();

    Future<void> _refreshChat() async {
      counselorprovider.getPeerCounsellors();
      print('refresh');
    }

    print(counselors);
    Widget peerCounsellorBuilder(BuildContext cxt, int index) {
      return Card(
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
                      placeholder: (context, url) => SpinKitFadingCircle(
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

    return counselors.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () => _refreshChat(),
            backgroundColor: Theme.of(context).primaryColor,
            color: Colors.white,
            displacement: 20.0,
            edgeOffset: 5.0,
            child: ListView.builder(
              itemBuilder: peerCounsellorBuilder,
              itemCount: counselors.length,
            ),
          )
        : Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child:
                  SpinKitSpinningLines(color: Theme.of(context).primaryColor),
            ),
          );
  }
}
