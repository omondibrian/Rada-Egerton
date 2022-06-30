import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/entities/information_data.dart';
import 'package:rada_egerton/data/providers/information_content.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/information/information_loading_placeholder.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/size_config.dart';
import 'package:go_router/go_router.dart';

class Information extends StatelessWidget {
  const Information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InformationProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Rada Information',
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.copyWith(color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => context.read<InformationProvider>().refresh(),
          child: Builder(
            builder: (context) {
              if (provider.status == ServiceStatus.loadingFailure) {
                return Row(
                  children: [
                    const Text("An error occurred"),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () =>
                          context.read<InformationProvider>().init(),
                      child: const Text("RETRY"),
                    )
                  ],
                );
              }
              if (provider.status == ServiceStatus.loadingSuccess) {
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      _contentListRow(context, provider, index),
                  itemCount: provider.informationCategory!.length,
                );
              }
              return const InformationListPlaceholder();
            },
          ),
        )
        //
        );
  }

  Widget _contentListRow(
      BuildContext context, InformationProvider provider, int index) {
    InformationCategory category = provider.informationCategory![index];
    List<InformationData> categoryData =
        provider.informationData!.where((item) {
      return item.metadata.category == category.id;
    }).toList();
    if (categoryData.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category.name,
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.left,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categoryData
                .map((item) => _informationCard(item, context))
                .toList(),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget _informationCard(
    InformationData informationItem,
    BuildContext context,
  ) {
    double imageHeight = SizeConfig.isTabletWidth ? 300 : 150;
    double imageWidth = SizeConfig.isTabletWidth ? 400 : 200;

    return InkWell(
      onTap: () => context.push(
        context.namedLocation(
          AppRoutes.informationDetails,
          params: {
            "id": informationItem.id.toString(),
          },
        ),
      ),
      child: Card(
        margin: const EdgeInsets.all(5.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl(
                  informationItem.metadata.thumbnail,
                ),
                placeholder: (context, url) => Image.asset(
                  "assets/gif.gif",
                  height: imageHeight,
                  width: imageWidth,
                ),
                imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    constraints:
                        const BoxConstraints(minHeight: 150, minWidth: 200),
                    height: imageHeight,
                    width: imageWidth),
              ),
            ),
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
