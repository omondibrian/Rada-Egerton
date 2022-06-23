import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';
import 'package:rada_egerton/resources/utils/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;
  final bool canEdit;
  Avatar(
      {Key? key,
      required this.imageUrl,
      required this.canEdit,
      this.borderColor = Colors.green,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);
  final ServiceUtility serviceUtility = ServiceUtility();
  @override
  Widget build(BuildContext context) {
    void _updateProfileImage() async {
      File imageFile = await ServiceUtility().uploadImage();
      try {
        String imageFileName = imageFile.path.split('/').last;
        FormData formData = FormData.fromMap(
          {
            "profilePic": await MultipartFile.fromFile(imageFile.path,
                filename: imageFileName),
          },
        );

        String authToken = await ServiceUtility.getAuthToken() as String;
        final profile = await Dio().put(
          url(url: "/api/v1/admin/user/profile"),
          data: formData,
          options: Options(
            headers: {
              'Authorization': authToken,
              "Content-type": "multipart/form-data",
            },
          ),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        User user = User.fromJson(profile.data["user"]);

        prefs.setString("user", userToJson(user));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Profile updated",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        );
      } on DioError catch (e) {
        ErrorMessage err = ServiceUtility.handleDioExceptions(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.message,
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
          ),
        );
      } catch (e) {
        print(e);
      }
    }

    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          maxRadius: SizeConfig.isTabletWidth ? 100 : 70,
          child: CircleAvatar(
            maxRadius: SizeConfig.isTabletWidth ? 97 : 67,
            backgroundImage: CachedNetworkImageProvider(
              imageUrl,
            ),
          ),
        ),
        if (canEdit)
          Positioned(
            left: 100,
            top: 90,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.black),
                onPressed: _updateProfileImage,
              ),
            ),
          ),
      ],
    );
  }
}
