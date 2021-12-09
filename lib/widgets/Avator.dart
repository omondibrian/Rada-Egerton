import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/sizeConfig.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key? key,
      required this.imageUrl,
      this.borderColor = Colors.green,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);
  void updateProfileImage() async {
    var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    File imageFile = File(pickedImage!.path);
    try {
      String imageFileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          "profilePic": await MultipartFile.fromFile(imageFile.path,
              filename: imageFileName),
        },
      );

      Future<String?> authToken = _authService.getAuthToken();

      await _httpConnection.put(
        '$BASE_URL/api/v1/admin/user/profile',
        data: formData,
        options: Options(
          headers: {
            'Authorization': authToken,
            "Content-type": "multipart/form-data",
          },
        ),
      );
    } catch (e) {
      //TODO:remove error specification statement
      print('Error from updateProfile : $e');
    }
  }
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
              imageUrl,
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
