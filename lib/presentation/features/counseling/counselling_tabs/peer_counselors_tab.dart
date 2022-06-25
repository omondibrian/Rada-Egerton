import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/data/entities/peer_counsellor_dto.dart';
import 'package:rada_egerton/data/providers/counseling_provider.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer_loading.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/size_config.dart';

class PeerCounsellorsTab extends StatelessWidget {
  const PeerCounsellorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counsellorprovider = Provider.of<CounsellingProvider>(context);
    var counsellors = counsellorprovider.peerCounsellors;

    Future<void> _refresh() async {
      counsellorprovider.initPeerCounsellors();
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(),
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      displacement: 20.0,
      edgeOffset: 5.0,
      child: Builder(
        builder: (context) {
          if (counsellorprovider.peerStatus == ServiceStatus.loading) {
            return Shimmer(
              child: ListView(
                children:
                    List.generate(4, (index) => placeHolderListTile(context)),
              ),
            );
          }
          if (counsellorprovider.peerStatus == ServiceStatus.loadingFailure) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text("An error occurred"),
                  TextButton(
                    onPressed: () => _refresh(),
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }
          if (counsellors.isEmpty &&
              counsellorprovider.peerStatus == ServiceStatus.loadingSuccess) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No peer counsellors available"),
            );
          }
          return ListView.builder(
            itemBuilder: (_, index) => _PeerCounsellorItem(counsellors[index]),
            itemCount: counsellors.length,
          );
        },
      ),
    );
  }
}

class _PeerCounsellorItem extends StatelessWidget {
  final PeerCounsellorDto counsellor;
  const _PeerCounsellorItem(this.counsellor, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _openForumn() {
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
      onTap: _openForumn,
      child: ListTile(
        minVerticalPadding: 0,
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        leading: CircleAvatar(
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
        title: Text(
          counsellor.user.name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(counsellor.expertise),
      ),
    );
  }
}

Widget placeHolderListTile(BuildContext context) => Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ShimmerLoading(
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: SizeConfig.isTabletWidth ? 100 : 80,
                height: SizeConfig.isTabletWidth ? 100 : 80,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                ShimmerLoading(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: MediaQuery.of(context).size.width * .6,
                      height: 30),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                ShimmerLoading(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: MediaQuery.of(context).size.width * .4,
                      height: 24),
                ),
              ],
            ),
          ])
        ],
      ),
    );
