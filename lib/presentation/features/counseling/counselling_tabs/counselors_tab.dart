import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/entities/counsellors_dto.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/peer_counselors_tab.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/rating_dialog.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';
import 'package:rada_egerton/presentation/widgets/rating_bar.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CounsellorsTab extends StatelessWidget {
  const CounsellorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counsellorprovider = Provider.of<CounsellingProvider>(context);
    final counsellors = counsellorprovider.counsellors;

    Future<void> _refresh() async {
      await counsellorprovider.refreshCounsellors();
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(),
      color: Theme.of(context).primaryColor,
      displacement: 20.0,
      edgeOffset: 5.0,
      child: Builder(
        builder: (context) {
          if (counsellorprovider.counsellorStatus == ServiceStatus.loading) {
            return Shimmer(
              child: ListView(
                children: List.generate(
                  4,
                  (index) => const TileLoader(),
                ),
              ),
            );
          }
          if (counsellorprovider.counsellorStatus ==
              ServiceStatus.loadingFailure) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text("An error occurred"),
                  TextButton(
                    onPressed: counsellorprovider.initCounsellors,
                    child: const Text("RETRY"),
                  )
                ],
              ),
            );
          }
          if (counsellors.isEmpty &&
              counsellorprovider.counsellorStatus ==
                  ServiceStatus.loadingSuccess) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Text("No counsellors available"),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) => _CounselloItem(
              counsellors[index],
            ),
            itemCount: counsellors.length,
          );
        },
      ),
    );
  }
}

class _CounselloItem extends StatelessWidget {
  final Counsellor counsellor;
  const _CounselloItem(this.counsellor, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _openForum() {
      if (counsellor.user.id == GlobalConfig.instance.user.id) {
        return;
      }
      context.pushNamed(
        AppRoutes.privateChat,
        params: {
          "recepientId": counsellor.user.id.toString(),
        },
      );
    }

    return GestureDetector(
      onTap: _openForum,
      child: ListTile(
        minVerticalPadding: 0,
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        leading: CircleAvatar(
          child: ClipOval(
            child: CachedNetworkImage(
              width: 90,
              height: 90,
              color: Colors.white,
              imageUrl: counsellor.user.profilePic,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                width: 90,
                height: 90,
              ),
              placeholder: (context, url) => Image.asset("assets/user.png"),
            ),
          ),
        ),
        title: Text(
          counsellor.user.name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(counsellor.expertise),
        trailing: InkWell(
          child: ratingBar(rating: counsellor.rating, size: 20),
          onTap: () => showDialog(
            context: context,
            builder: (context) => CounsellorRatingDialog(
              counsellorId: counsellor.counsellorId.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
