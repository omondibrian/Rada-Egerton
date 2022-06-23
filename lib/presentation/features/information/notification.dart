import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/data/entities/NewsDTO.dart';
import 'package:rada_egerton/data/services/NewsAndLocation/main.dart';


class UserNotification extends StatefulWidget {
  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  List<News>? _news;
  NewsAndLocationServiceProvider service = NewsAndLocationServiceProvider();
  Future<void> init() async {
    final result = await service.fetchNews();
    result.fold(
        (l) => setState(() {
              _news = l;
            }),
        (r) => {
              //TODO:handle errors
            });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> _refresh() async {
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Notification',
        style: Theme.of(context)
            .textTheme
            .headline1
            ?.copyWith(color: Colors.white),
      )),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        displacement: 20.0,
        edgeOffset: 5.0,
        child: _news == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _news!.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("No notification available"),
                  )
                : ListView(
                    children:
                        _news!.map((item) => notificationCard(item)).toList(),
                  ),
      ),
    );
  }

  Widget notificationCard(News notification) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: notification.imageUrl,
                  placeholder: (context, url) => SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    height: 50,
                    width: 50,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      notification.content,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ],
            ),
            Text(
              "1h",
              //todo: add time
              // TimeAgo.timeAgoSinceDate(notification.timeCreated),
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }
}
