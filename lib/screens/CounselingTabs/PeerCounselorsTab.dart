import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/providers/chat.provider.dart';
import 'package:rada_egerton/providers/counselling.provider.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';

import '../../sizeConfig.dart';

class PeerCounselorsTab extends StatelessWidget {
  const PeerCounselorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    final applicationProvider = Provider.of<RadaApplicationProvider>(context);
    final chatsprovider = Provider.of<ChatProvider>(context);
    var counselors = counselorprovider.peerCounselors;

    Future<void> _refresh() async {
      counselorprovider.getPeerCounsellors();
    }

    Widget peerCounsellorBuilder(BuildContext cxt, int index) {
      var peerCounsellors = counselors[index];
      return GestureDetector(
        onTap: () {
          //prevent
          if (peerCounsellors.id.toString() == applicationProvider.user!.id) {
            return null;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                title: '${peerCounsellors.name}',
                imgUrl:
                    "$BASE_URL/api/v1/uploads/${peerCounsellors.profilePic}",
                sendMessage: chatsprovider.sendPrivateCounselingMessage,
                groupId: "",
                reciepient: peerCounsellors.id.toString(),
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
                        imageUrl:
                            "$BASE_URL/api/v1/uploads/${peerCounsellors.profilePic}",
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
                            CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
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
                      counselors[index].name,
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

    return counselorprovider.peerCouselorsLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : RefreshIndicator(
            onRefresh: () => _refresh(),
            backgroundColor: Theme.of(context).primaryColor,
            color: Colors.white,
            displacement: 20.0,
            edgeOffset: 5.0,
            child: counselors.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemBuilder: peerCounsellorBuilder,
                      itemCount: counselors.length,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No peer couselor available"),
                  ),
          );
  }
}
