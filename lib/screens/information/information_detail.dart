import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/theme.dart';

class InformationDetail extends StatefulWidget {
  @override
  _InformationDetailState createState() => _InformationDetailState();
}

class _InformationDetailState extends State<InformationDetail> {
  final Map<String, dynamic> informationItem = {
    "image":
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    "title": "item3",
    "description":
        "Drug abuse and addiction, now both grouped as substance or drug use disorder, is a condition characterized by a self-destructive pattern of using a substance that leads to significant problems and distress, which may include tolerance to or withdrawal from the substance. Drug use disorder is unfortunately quite common, affecting more than 8% of people in the United States at"
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: informationItem["image"],
                placeholder: (context, url) => SpinKitFadingCircle(
                  color: Theme.of(context).primaryColor,
                ),
              ),

              // Image.network(
              //   informationItem["image"],
              //   width: MediaQuery.of(context).size.width,
              //   fit: BoxFit.cover,
              //   height: 300,
              // ),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              informationItem["title"],
              style: Theme.of(context).textTheme.headline1?.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: Palette.primary,
                  decorationThickness: 2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              informationItem["description"],
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      )),
    );
  }
}
