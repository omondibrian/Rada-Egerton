import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sizeConfig.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  late UserDTO? profile = UserDTO();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Dio _httpConnection = Dio();

  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> getAuthToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String? token = _preferences.getString("TOKEN");
    return token;
  }

  Future<void> updateProfileImage() async {
    var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    File imageFile = File(pickedImage!.path);
    try {
      String imageFileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profilePic": await MultipartFile.fromFile(imageFile.path,
            filename: imageFileName),
      });
      Future<String?> authToken = getAuthToken();
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
      print(e);
    }
  }

  Future<void> initializeState() async {
    AuthServiceProvider _authService = AuthServiceProvider();
    final results = await _authService.getProfile();
    // print(results);
    if (results!.id.isNotEmpty) {
      setState(() {
        widget.profile = results;
      });
    }
  }

  Widget textField(String hintTextfield) {
    return Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: TextEditingController()..text = hintTextfield,
          decoration: InputDecoration(
            hintText: "Username",
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
            ),
            fillColor: Colors.black12,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ));
  }

  Widget textLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget textValue(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.initializeState();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Profile'),
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: widget.profile == null
          ? Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child:
                    SpinKitSpinningLines(color: Theme.of(context).primaryColor),
              ),
            )
          : Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              "$BASE_URL/api/v1/uploads/${widget.profile?.profilePic}",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: SizeConfig.isTabletWidth ? 150 : 120,
                            height: SizeConfig.isTabletWidth ? 150 : 120,
                          ),
                          placeholder: (context, url) => SpinKitFadingCircle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        
                        Positioned(
                          left: 80,
                          top: 80,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.black),
                              onPressed: () {
                                updateProfileImage();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(widget.profile!.userName,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    )),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 10, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textLabel('University'),
                      textLabel('Campus'),
                      textLabel('Sex')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textValue('Egerton'),
                      textValue('1'),
                      textValue(widget.profile!.gender),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 20, right: 20, bottom: 20),
                  child: TextField(
                    controller: TextEditingController()
                      ..text = widget.profile!.userName,
                    decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(
                          letterSpacing: 2,
                          color: Colors.black54,
                        ),
                        fillColor: Colors.black12,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 18),
                      ),
                    ),
                    // TODO: create the update password function
                    onPressed: () {},
                    child: Center(
                      child: Text("Change password"),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
