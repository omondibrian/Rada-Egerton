import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/informationData.dart';
import 'package:rada_egerton/providers/information.content.dart';
import 'package:rada_egerton/screens/information/information_detail.dart';
import 'package:rada_egerton/sizeConfig.dart';

class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = [];
    final _provider = Provider.of<InformationProvider>(context);
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
                child: RefreshIndicator(
                  onRefresh: () => _provider.init(),
                  child: _provider.informationData == null
                      ? CircularProgressIndicator()
                      : Row(
                          children: _provider.informationData!
                              .map((item) => _informationCard(item, context))
                              .toList()
                          // itemBuilder: (_, index) => _informationCard(
                          //   _provider.informationData![index],
                          //   context,
                          // ),
                          // itemCount: _provider.informationData!.length,
                          ),
                )),
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
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //       children: imageSliders,
            //       mainAxisAlignment: MainAxisAlignment.center),
            // ),
          ],
        ),
      ),

      //
    );
  }

  Widget _informationCard(
    InformationData informationItem,
    BuildContext context,
  ) {
    double _imageHeight = SizeConfig.isTabletWidth ? 300 : 150;
    double _imageWidth = SizeConfig.isTabletWidth ? 400 : 200;
    
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InformationDetail(informationItem))),
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
                  imageUrl: "$IMAGE_URL${informationItem.metadata.thumbnail}",
                  placeholder: (context, url) => Image.asset(
                    "assets/gif.gif",
                    height: _imageHeight,
                    width: _imageWidth,
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
                      constraints:
                          BoxConstraints(minHeight: 150, minWidth: 200),
                      height: _imageHeight,
                      width: _imageWidth),
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
