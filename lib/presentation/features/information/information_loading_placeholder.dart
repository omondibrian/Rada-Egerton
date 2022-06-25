import 'package:flutter/material.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer_loading.dart';
import 'package:rada_egerton/resources/size_config.dart';

class InformationListPlaceholder extends StatelessWidget {
  const InformationListPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageHeight = SizeConfig.isTabletWidth ? 300 : 150;
    double imageWidth = SizeConfig.isTabletWidth ? 400 : 200;
    int cols = (MediaQuery.of(context).size.width / (imageWidth + 30)).round();
    int rows =
        (MediaQuery.of(context).size.height / (imageHeight + 50)).round();
    return Shimmer(
      child: ListView(
        children: List.generate(
          rows,
          (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoading(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    cols,
                    (index) =>
                        _informationCard(context, imageHeight, imageWidth),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _informationCard(
      BuildContext context, double imageHeight, double imageWidth) {
    return ShimmerLoading(
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
              child: Container(
                height: imageHeight,
                width: imageWidth,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Container(
                width: 150,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
