import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/informationData.dart';
import 'package:rada_egerton/providers/information.content.dart';

class InformationDetail extends StatefulWidget {
  final InformationData informationData;
  InformationDetail(this.informationData);
  @override
  _InformationDetailState createState() => _InformationDetailState();
}

class _InformationDetailState extends State<InformationDetail> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<InformationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.informationData.metadata.title,
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _provider.informationData == null
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemBuilder: (context, index) => informationBodyContent(
                      widget.informationData.content[index],
                    ),
                    itemCount: widget.informationData.content.length,
                  )),
      ),
    );
  }

  Widget informationBodyContent(InformationContent content) {
    if (content.bodyContent.length < 1 && content.subtitle == null) {
      return SizedBox(
        height: 0,
      );
    }
    if (content.bodyContent.length < 1 && content.subtitle != null) {
      return Card(
        child: Text("${content.subtitle}"),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      
      child: Column(
        children: [
          if (content.subtitle != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                content.subtitle!,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          if (content.type == InformationContent.text)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(content.bodyContent[0],
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          if (content.type == InformationContent.image)
            CachedNetworkImage(
              imageUrl: "$IMAGE_URL${content.bodyContent[0]}",
            ),
          if (content.type == InformationContent.list)
            Column(
              children: content.bodyContent
                  .map(
                    (item) => Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Text(
                        "$item",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  )
                  .toList(),
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
