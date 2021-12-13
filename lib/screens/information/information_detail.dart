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
              padding: const EdgeInsets.all(10.0),
              child: _provider.informationData == null
                  ? CircularProgressIndicator()
                  : ListView(
                      children: buildItems(widget.informationData.content),
                    ))),
    );
  }

  List<Widget> buildItems(List<InformationContent> contentItems) {
    List<Widget> _widgets = [];
    int i = 0;
    late Widget _widget;
    while (i < contentItems.length) {
      if (contentItems[i].type == InformationContent.text) {
        List<InlineSpan> span = [];
        //to render list items

        for (int l = i; l < contentItems.length; l++) {
          if (contentItems[l].type == InformationContent.text) {
            if (l < contentItems.length - 1 &&
                contentItems[l + 1].attributes.list != null) {
              span.add(WidgetSpan(
                  child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("\u2022 ${contentItems[l].bodyContent}",
                    style: contentItems[l].getTextStyle),
              )));
            } else {
              span.add(TextSpan(
                  text: "${contentItems[l].bodyContent}",
                  style: contentItems[l].getTextStyle));
            }
            i += 1;
          } else {
            break;
          }
        }
        _widget = Text.rich(TextSpan(children: span));
        _widgets.add(_widget);
      } else if (contentItems[i].type == InformationContent.image) {
        _widget = CachedNetworkImage(
          imageUrl: "$IMAGE_URL${contentItems[i].bodyContent}",
        );
        _widgets.add(_widget);
        i += 1;
      }
    }

    return _widgets;
  }

  Widget informationBodyContent(InformationContent content) {
    print(content.attributes.header);
    if (content.subtitle != null)
      return Text(
        content.subtitle!,
        style: Theme.of(context).textTheme.subtitle1,
      );
    if (content.type == InformationContent.text)
      return Text(content.bodyContent, style: content.getTextStyle);
    if (content.type == InformationContent.image)
      return Image.network(
        "$IMAGE_URL${content.bodyContent}",
      );
    if (content.type == InformationContent.title)
      return Text(
        content.bodyContent,
        style: Theme.of(context).textTheme.headline3,
      );
    return SizedBox();
  }
}
