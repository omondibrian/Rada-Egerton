import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/widgets/ProfileHeader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:form_field_validator/form_field_validator.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserDTO _user;

  Future<void> initializeState() async {
    AuthServiceProvider _authService = AuthServiceProvider();
    final results = await _authService.getProfile();
    results!.fold((user) {
      setState(() => _user = user);

      print('user data from initializeState() ${user.userName}');
    }, (r) => print(r));
  }

  bool userInfoControllerStatus = true;

  Dio _httpConnection = Dio();
  final ImagePicker _imagePicker = ImagePicker();

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

  @override
  void initState() {
    initializeState();
    initializeDetails();
    super.initState();
  }

  void initializeDetails() {
    _lastNameController.text = _user.userName;
    _emailController.text = _user.email;
    _phoneNumberController.text = _user.phone;
    _genderController.text = _user.gender;
    _dateOfBirthController.text = _user.dob;

    print(_user.userName);
    print('Last Name controller value : ${_lastNameController.value}');
  }

  GlobalKey<FormState> profileForm = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _user.id.isEmpty
          ? Text('loading')
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    avatar: CachedNetworkImageProvider(
                      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                    ),
                    coverImage: AssetImage('assets/android-icon-192x192.png'),
                    title: "${_user.userName}", //TODO: fetch username

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
                              userInfoControllerStatus =
                                  !userInfoControllerStatus;
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
                    child: Column(
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
                              //TODO supply form key
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter userName",
                                    ),
                                    enabled: !userInfoControllerStatus,
                                    controller: _lastNameController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter ", //TODOS
                                    ),
                                    enabled: !userInfoControllerStatus,
                                    controller: _emailController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter gender",
                                    ),
                                    enabled: !userInfoControllerStatus,
                                    controller: _genderController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter date of birth",
                                    ),
                                    enabled: !userInfoControllerStatus,
                                    controller: _dateOfBirthController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter phone number",
                                    ),
                                    enabled: !userInfoControllerStatus,
                                    controller: _phoneNumberController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.account_box_outlined),
                                    title: Text("Account status"),
                                    subtitle: Text(
                                        "${_user.email}"), //TODO fetch user account status
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.calendar_today),
                                    title: Text("Date joined"),
                                    subtitle: Text(
                                        "${_user.email}"), //TODO fetch the date the user joined
                                  ),
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
}
