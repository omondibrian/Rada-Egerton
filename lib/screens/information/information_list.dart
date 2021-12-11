import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/informationData.dart';
import 'package:rada_egerton/screens/information/information_detail.dart';

class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = [];
    return Scaffold(
      appBar: AppBar(
          title: Text('Rada Information',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(color: Colors.white))),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Sexual & Reproductive health",
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.left,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: imageSliders),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Substance abuse",
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.left,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: imageSliders,
                  mainAxisAlignment: MainAxisAlignment.center),
            ),
          ],
        ),
      ),

      //
    );
  }

  Widget informationCard(
    InformationData informationItem,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InformationDetail( informationItem))),
      child: Card(
        margin: EdgeInsets.all(5.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: informationItem.metadata.thumbnail,
                  placeholder: (context, url) => SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    height: 150,
                    width: 200,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Text(
                informationItem.metadata.title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
