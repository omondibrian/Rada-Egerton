import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/UserChatsDTO.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/services/counseling/main.dart';
import 'package:rada_egerton/widgets/ChatsScreen.dart';
import 'package:rada_egerton/widgets/ratingBar.dart';
import '../../providers/counselors.provider.dart';
import '../../sizeConfig.dart';

class CounselorsTab extends StatelessWidget {
  const CounselorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counselorprovider = Provider.of<CounselorProvider>(context);
    var counselors = counselorprovider.counselors;

    Future<void> _refresh() async {
      counselorprovider.getCounsellors();
    }

    sendMessage(ChatPayload chat, String userId) async {
      var service = CounselingServiceProvider();
      await service.peerCounseling(chat, userId);
    }

    Widget conselorsBuilder(BuildContext cxt, int index) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen<PeerMsg>(
              title: counselors[index].name,
              imgUrl: "$BASE_URL/api/v1/uploads/${counselors[index].imgUrl}",
              msgs: [],
              sendMessage: sendMessage,
              groupId: counselors[index].id.toString(),
              reciepient: counselors[index].id.toString(),
            ),
          ),
        ),
        child: Card(
          elevation: 1,
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: SizeConfig.isTabletWidth ? 40 : 20.0,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            "$BASE_URL/api/v1/uploads/${counselors[index].imgUrl}",
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Expertise : '),
                    Text(
                      counselors[index].expertise,
                    ),
                  ],
                ),
                Row(
                  children: [
                    ratingBar(rating: counselors[index].rating, size: 20),
                  ],
                ),
              ])
            ],
          ),
        ),
      );
    }

    return counselorprovider.counselorsLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : counselors.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () => _refresh(),
                backgroundColor: Theme.of(context).primaryColor,
                color: Colors.white,
                displacement: 20.0,
                edgeOffset: 5.0,
                child: ListView.builder(
                  itemBuilder: conselorsBuilder,
                  itemCount: counselors.length,
                ),
              )
            : Padding(
                padding: EdgeInsets.all(8),
                child: Text("No counselors available"),
              );
  }
}
