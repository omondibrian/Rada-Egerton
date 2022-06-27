import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/news_dto.dart';
import 'package:rada_egerton/data/services/news_location_service.dart';
import 'package:rada_egerton/presentation/features/counseling/counselling_tabs/peer_counselors_tab.dart';
import 'package:rada_egerton/presentation/loading_effect/shimmer.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

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
      (r) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              r.message,
              style: const TextStyle(color: Colors.red),
            ),
            action: SnackBarAction(
              label: "RETRY",
              onPressed: init,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: init,
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          displacement: 20.0,
          edgeOffset: 5.0,
          child: Builder(
            builder: (context) {
              if (_news == null) {
                return Shimmer(
                  child: ListView(
                    children: List.generate(
                      4,
                      (index) => const TileLoader(),
                    ),
                  ),
                );
              }
              if (_news!.isEmpty) {
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No notification available"),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) => _notificationItem(
                  _news![index],
                ),
                itemCount: _news!.length,
              );
            },
          )),
    );
  }

  Widget _notificationItem(News notification) {
    return ListTile(
      leading: CachedNetworkImage(
        height: 50,
        width: 50,
        imageUrl: notification.imageUrl,
        placeholder: (context, url) => Image.asset(
          "assets/gif.gif",
          height: 100,
          width: 100,
        ),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          height: 100,
          width: 100,
        ),
      ),
      title: Text(
        notification.title,
        style: Theme.of(context).textTheme.headline3,
      ),
      subtitle: Text(
        notification.content,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: Text(
        "1h",
        //TODO: add time
        // TimeAgo.timeAgoSinceDate(notification.timeCreated),
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
