import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/sizeConfig.dart';

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key? key,
      required this.image,
      this.borderColor = Colors.green,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          maxRadius: SizeConfig.isTabletWidth ? 100 : 70,
          child: CircleAvatar(
            maxRadius: SizeConfig.isTabletWidth ? 97 : 67,
            backgroundImage: CachedNetworkImageProvider(
              'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
            ),
          ),
        ),
        Positioned(
          left: 100,
          top: 90,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.black),
              onPressed: () {
                // updateProfileImage();//TODO: sort this function out
              },
            ),
          ),
        ),
      ],
    );
  }
}