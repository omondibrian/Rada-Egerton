import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/constants.dart';

class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders =
        informationItems.map((item) => informationCard(item, context)).toList();
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

  Widget informationCard(Map<String, dynamic> item, BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRoutes.informationDetails),
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
                  imageUrl: item["image"],
                  placeholder: (context, url) => SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                  ),
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: 200,
                      maxHeight: 150,
                      minWidth: 180,
                      minHeight: 135,
                    ),
                  ),
                )
                //TODO : fix image not showing error on information screen
                // Image.network(
                //   item["image"],
                //   fit: BoxFit.cover,
                //   width: 200,
                //   height: 150,
                // ),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Text(
                item["title"],
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> informationItems = [
  {
    "image":
        'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    "title": "Love"
  },
  {
    "image":
        'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    "title": "item2"
  },
  {
    "image":
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    "title": "item3"
  },
  {
    "image":
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    "title": "item3"
  }
];
