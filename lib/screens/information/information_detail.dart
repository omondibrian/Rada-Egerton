import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/informationData.dart';

class InformationDetail extends StatefulWidget {
  final InformationData informationData;
  InformationDetail(this.informationData);
  @override
  _InformationDetailState createState() => _InformationDetailState();
}

class _InformationDetailState extends State<InformationDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) => informationBodyContent(
              widget.informationData.content[index],
            ),
          ),
        ),
      ),
    );
  }

  Widget informationBodyContent(InformationContent content) {
    return Card(
      child: Column(
        children: [
          if (content.subtitle != null)
            Text(
              content.subtitle!,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          if (content.type == InformationContent.text)
            Text(content.bodyContent[0],
                style: Theme.of(context).textTheme.bodyText1),
          if (content.type == InformationContent.image)
            CachedNetworkImage(
              imageUrl: content.bodyContent[0],
            ),
          if (content.type == InformationContent.list)
            ListView.builder(
              itemBuilder: (cxt, index) => Text(
                "${index + 1}. ${content.bodyContent[index]}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              itemCount: content.bodyContent.length,
            ),
          if (content.type == InformationContent.title)
            Text(
              content.bodyContent[0],
              style: Theme.of(context).textTheme.headline3,
            ),
        ],
      ),
    );
  }
}
