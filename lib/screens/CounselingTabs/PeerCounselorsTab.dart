import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/loading_effect/shimmer.dart';
import 'package:rada_egerton/loading_effect/shimmer_loading.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';

import '../../sizeConfig.dart';

class PeerCounsellorsTab extends StatelessWidget {
  const PeerCounsellorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counsellorprovider = Provider.of<CounsellorProvider>(context);
    final applicationProvider = Provider.of<RadaApplicationProvider>(context);
    final chatsprovider = Provider.of<ChatProvider>(context);
    var counsellors = counsellorprovider.peerCounsellors;

    Future<void> _refresh() async {
      counsellorprovider.getPeerCounsellors();
    }

    Widget peerCounsellorBuilder(BuildContext cxt, int index) {
      var peerCounsellors = counsellors![index];
      return GestureDetector(
        onTap: () {
          //prevent
          if (peerCounsellors.user.id == applicationProvider.user!.id) {
            return null;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                title: '${peerCounsellors.user.name}',
                imgUrl:
                    "$BASE_URL/api/v1/uploads/${peerCounsellors.user.profilePic}",
                sendMessage: chatsprovider.sendPrivateCounselingMessage,
                groupId: "",
                reciepient: peerCounsellors.user.id.toString(),
                chatIndex: index,
                mode: ChatModes.PRIVATE,
              ),
            ),
          );
        },
        child: Card(
          elevation: 0,
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        color: Colors.white,
                        imageUrl:
                            "$BASE_URL/api/v1/uploads/${peerCounsellors.user.profilePic}",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: SizeConfig.isTabletWidth ? 120 : 90,
                          height: SizeConfig.isTabletWidth ? 120 : 90,
                        ),
                        placeholder: (context, url) =>
                            Image.asset("assets/user.png"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Text(
                      counsellors[index].user.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Expertise : ',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontSize: 14)),
                    Text(
                      peerCounsellors.expertise,
                    ),
                  ],
                ),
              ])
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(),
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      displacement: 20.0,
      edgeOffset: 5.0,
      child: counsellors == null
          ? Shimmer(
              child: ListView(
                children:
                    List.generate(4, (index) => placeHolderListTile(context)),
              ),
            )
          : counsellors.isEmpty
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No peer counsellors available"),
              )
              : ListView.builder(
                itemBuilder: peerCounsellorBuilder,
                itemCount: counsellors.length,
              ),
    );
  }
}

Widget placeHolderListTile(BuildContext context) => Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10),
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
          SizedBox(
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
            SizedBox(
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
