import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/widgets/ratingBar.dart';
import '../../providers/counselors.provider.dart';
import '../../sizeConfig.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CounselorsTab extends StatelessWidget {
  const CounselorsTab({Key? key}) : super(key: key);

  Future<void> _refreshChat() async {
    //TODO : function call to refresh chat data
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var counselors = counselorprovider.counselors;
    counselorprovider.getCounsellors();
    Widget conselorsBuilder(BuildContext cxt, int index) {
      return Card(
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: SizeConfig.isTabletWidth ? 40 : 20.0,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: counselors[index].imgUrl,
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
              Row(
                children: [
                  ratingBar(rating: counselors[index].rating, size: 20),
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
              itemBuilder: conselorsBuilder,
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
