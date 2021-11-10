import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/widgets/ratingBar.dart';
import '../../providers/counselors.provider.dart';
import '../../sizeConfig.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CounselorsTab extends StatelessWidget {
  const CounselorsTab({Key? key}) : super(key: key);

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
                    child: Image.network(
                      counselors[index].imgUrl,
                      width: SizeConfig.isTabletWidth ? 120 : 90,
                      height: SizeConfig.isTabletWidth ? 120 : 90,
                      fit: BoxFit.cover,
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
        ? ListView.builder(
            itemBuilder: conselorsBuilder,
            itemCount: counselors.length,
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
