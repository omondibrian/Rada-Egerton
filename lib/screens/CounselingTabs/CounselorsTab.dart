import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/widgets/ratingBar.dart';
import '../../providers/counselors.provider.dart';

class CounselorsTab extends StatelessWidget {
  const CounselorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var counserlors = counselorprovider.counselors;
    counselorprovider.getCounsellors();
    Widget conselorsBuilder(BuildContext cxt, int index) {
      return Card(
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  child: Image.network(
                    counserlors[index].imgUrl,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    counserlors[index].name,
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Expertise : '),
                  Text(
                    counserlors[index].expertise,
                  ),
                ],
              ),
              Row(
                children: [
                  ratingBar(rating: counserlors[index].rating, size: 20),
                ],
              ),
            ])
          ],
        ),
      );
    }

    return counserlors.isNotEmpty
        ? ListView.builder(
            itemBuilder: conselorsBuilder,
            itemCount: counserlors.length,
          )
        : Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(),
            ),
          );
  }
}
