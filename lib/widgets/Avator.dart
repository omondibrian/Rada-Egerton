import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/sizeConfig.dart';
import 'package:rada_egerton/utils/main.dart';
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
    final _appProvider = Provider.of<RadaApplicationProvider>(context);
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
        final _profile = await Dio().put(
          '$BASE_URL/api/v1/admin/user/profile',
          data: formData,
          options: Options(
            headers: {
              'Authorization': authToken,
              "Content-type": "multipart/form-data",
            },
          ),
        );
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        UserDTO user = UserDTO.fromJson(_profile.data["user"]);

        _prefs.setString("user", userDtoToJson(user));
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
                icon: Icon(Icons.camera_alt, color: Colors.black),
                onPressed: _updateProfileImage,
              ),
            ),
          ),
      ],
    );
  }
}
