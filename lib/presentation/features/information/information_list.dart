import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/entities/informationData.dart';
import 'package:rada_egerton/data/providers/information.content.dart';
import 'package:rada_egerton/presentation/features/information/information_detail.dart';
import 'package:rada_egerton/presentation/features/information/information_loading_placeholder.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';

class Information extends StatelessWidget {
  const Information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InformationProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text('Rada Information',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(color: Colors.white))),
      body: Container(
        // margin: EdgeInsets.symmetric(vertical: 30),
        child: provider.informationCategory == null ||
                provider.informationData == null
            ? InformationListPlaceholder()
            : ListView.builder(
                itemBuilder: (context, index) =>
                    _contentListRow(context, provider, index),
                itemCount: provider.informationCategory!.length,
              ),
      ),

      //
    );
  }

  Widget _contentListRow(
      BuildContext context, InformationProvider _provider, int index) {
    InformationCategory _category = _provider.informationCategory![index];
    List<InformationData> _categoryData =
        _provider.informationData!.where((item) {
      return item.metadata.category == _category.id;
    }).toList();
    if (_categoryData.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${_category.name}",
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.left,
          ),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: _categoryData
                    .map((item) => _informationCard(item, context))
                    .toList())),
        SizedBox(
          height: 30,
        ),
      ],
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
                  imageUrl: imageUrl(
                    informationItem.metadata.thumbnail,
                  ),
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
