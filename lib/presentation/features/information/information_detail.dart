import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/entities/information_data.dart';
import 'package:rada_egerton/data/providers/information.content.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Builder(
          builder: (context) {
            InformationData? data = getData();
            if (provider.status == ServiceStatus.loadingFailure) {
              return Row(
                children: [
                  const Text(
                    "An error occured while loading the data",
                  ),
                  TextButton(
                    onPressed: () => context.read<InformationProvider>().init(),
                    child: const Text("RETRY"),
                  )
                ],
              );
            }
            if (data != null) {
              return ListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 400, minWidth: 100),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl(data.metadata.thumbnail),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: SelectableText(
                      data.metadata.title,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  buildChatContent(
                    data.content,
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

Widget _link(String url, Widget child) {
  return InkWell(
    child: child,
    onTap: () async {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      }
    },
  );
}

Widget buildChatContent(List<InformationContent> contentItems) {
  int i = 0;
  List<InlineSpan> span = [];
  //----------------------------------------------------//
  //Render rich text created with Quil.js WYSIWYG editor//
  //----------------------------------------------------//

  bool isList(int i) {
    return i < contentItems.length - 1 &&
        contentItems[i + 1].attributes.list != null;
  }

  for (i = 0; i < contentItems.length; i++) {
    var item = contentItems[i];
    if (item.type == InformationContent.text) {
      String text = isList(i)
          ? "${'\t' * 3}\u2022 ${item.bodyContent}"
          : item.bodyContent;
      //links
      if (item.attributes.link != null) {
        span.add(
          WidgetSpan(
            child: _link(
              item.attributes.link!,
              Text(text, style: item.getTextStyle),
            ),
          ),
        );
      } else {
        span.add(
          TextSpan(text: text, style: item.getTextStyle),
        );
      }
    } else if (item.type == InformationContent.image) {
      span.add(
        WidgetSpan(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400, minWidth: 100),
              child: CachedNetworkImage(
                imageUrl: imageUrl(contentItems[i].bodyContent),
                placeholder: (context, url) => Image.asset(
                  "assets/gif.gif",
                  height: 200,
                  width: 400,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  return SelectableText.rich(
    TextSpan(children: span),
  );
}
