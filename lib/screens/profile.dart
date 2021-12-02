import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/services/utils.dart';
import 'package:rada_egerton/widgets/RadaButton.dart';
import '../sizeConfig.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserDTO? userProfile;
  GlobalKey<FormState> _profileForm = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  bool _editStatus = false;
  Future<void> init() async {
    AuthServiceProvider _authService = AuthServiceProvider();
    final results = await _authService.getProfile();
    results!.fold((l) {
      userProfile = l;
      _userNameController.text = userProfile!.userName;
      _emailController.text = userProfile!.email;
      _phoneNumberController.text = userProfile!.phone;

      setState(() {});
    }, (r) => print(r));

    Dio _httpConnection = Dio();

    final ImagePicker _imagePicker = ImagePicker();
    void updateProfileImage() async {
      var pickedImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      File imageFile = File(pickedImage!.path);
      try {
        String imageFileName = imageFile.path.split('/').last;
        FormData formData = FormData.fromMap(
          {
            "profilePic": await MultipartFile.fromFile(imageFile.path,
                filename: imageFileName),
          },
        );

        Future<String?> authToken = ServiceUtility.getAuthToken();

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
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // initializeResults();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileHeader(
              avatar: CachedNetworkImageProvider(
                'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
              ),
              coverImage: AssetImage('assets/android-icon-192x192.png'),
              title: userProfile == null ? "User Name" : userProfile!.userName,
              actions: <Widget>[
                MaterialButton(
                  color: Colors.white,
                  shape: CircleBorder(side: BorderSide.none),
                  elevation: 0,
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        _editStatus = !_editStatus;
                      },
                    );
                    //TODO: implement edit details function
                  },
                )
              ],
            ),
            const SizedBox(height: 10.0),
            // UserInfo(),

            //TODO: insert userinfo stless widget
            Container(
              padding: EdgeInsets.all(10),
              child: userProfile == null
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black87),
                    )
                  : Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Profile Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(15),
                            child: Form(
                              key: _profileForm,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter user name",
                                    ),
                                    enabled: _editStatus,
                                    controller: _userNameController,
                                    autofocus: true,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter email address",
                                    ),
                                    enabled: _editStatus,
                                    controller: _emailController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter phone number",
                                    ),
                                    enabled: _editStatus,
                                    controller: _phoneNumberController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.account_box_outlined),
                                    title: Text("Account status"),
                                    subtitle: Text(
                                        "${userProfile?.email}"), //TODO fetch user account status
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.calendar_today),
                                    title: Text("Date joined"),
                                    subtitle: Text("${userProfile?.email}"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.calendar_today),
                                    title: Text("Date of birth"),
                                    subtitle: Text("${userProfile?.dob}"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text("Gender"),
                                    subtitle: Text("${userProfile?.gender}"),
                                  ),
                                  _editStatus
                                      ? _getActionButtons()
                                      : SizedBox(
                                          height: 50,
                                        )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: RadaButton(
              title: 'Save',
              handleClick: () => {}, //TODO: -update profile
              fill: true,
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: RadaButton(
              title: 'Cancel',
              handleClick: () => {
                setState(() => {_editStatus = false})
              },
              fill: false,
            ),
          ),
          flex: 2,
        ),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final AssetImage coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const ProfileHeader(
      {Key? key,
      required this.coverImage,
      required this.avatar,
      required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 50,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline1,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

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
// Container(
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     image: DecorationImage(
            //       image: imageProvider,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            //   width: SizeConfig.isTabletWidth ? 150 : 120,
            //   height: SizeConfig.isTabletWidth ? 150 : 120,
            // ),
            // placeholder: (context, url) => SpinKitFadingCircle(
            //   color: Theme.of(context).primaryColor,
            // ),