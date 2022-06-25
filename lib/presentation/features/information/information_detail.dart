import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/entities/information_data.dart';
import 'package:rada_egerton/data/providers/information.content.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/config.dart';

class InformationDetailPage extends StatelessWidget {
  final String infoId;
  const InformationDetailPage(this.infoId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InformationProvider>(context);
    InformationData? getData() {
      InformationData? informationData;
      if (provider.status == ServiceStatus.loadingSuccess) {
        informationData = provider.informationData!
            .where(
              (value) => value.id.toString() == infoId,
            )
            .first;
      }
      return informationData;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getData()?.metadata.title ?? "Loading",
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.white),
        ),
      ),
      body: Builder(builder: (context) {
        if (provider.status == ServiceStatus.loadingFailure) {
          return Row(
            children: [
              const Text(
                "An error occured while loading the data",
              ),
              TextButton(
                onPressed: () => context.read<InformationProvider>().init(),
                child: const Text("Retry"),
              )
            ],
          );
        }
        if (provider.status == ServiceStatus.loadingSuccess) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: buildItems(
                  getData()!.content,
                ),
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  List<Widget> buildItems(List<InformationContent> contentItems) {
    List<Widget> widgets = [];
    int i = 0;
    late Widget widget;
    while (i < contentItems.length) {
      if (contentItems[i].type == InformationContent.text) {
        List<InlineSpan> span = [];
        //----------------------------------------------------//
        //Render rich text created with Quil.js WYSIWYG editor//
        //----------------------------------------------------//

        /**
         * take all consercutive text items and render them using InlineSpan element
         * stop whenever an image  in encounterd
         */
        for (int l = i; l < contentItems.length; l++) {
          if (contentItems[l].type == InformationContent.text) {
            if (l < contentItems.length - 1 &&
                contentItems[l + 1].attributes.list != null) {
              span.add(WidgetSpan(
                  child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("\u2022 ${contentItems[l].bodyContent}",
                    style: contentItems[l].getTextStyle),
              )));
            } else {
              span.add(TextSpan(
                  text: contentItems[l].bodyContent,
                  style: contentItems[l].getTextStyle));
            }
            i += 1;
          } else {
            break;
          }
        }
        widget = Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text.rich(
              TextSpan(children: span),
            ),
          ),
        );
        widgets.add(widget);
      } /**
         stop when an image is encountered
       */
      else if (contentItems[i].type == InformationContent.image) {
        widget = Card(
            child: CachedNetworkImage(
          imageUrl: imageUrl(contentItems[i].bodyContent),
        ));
        widgets.add(widget);
        i += 1;
      }
    }

    return widgets;
  }
}
