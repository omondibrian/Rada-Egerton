import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sizeConfig.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  late UserDTO? profile = UserDTO();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _status = true;
  Dio _httpConnection = Dio();
  final FocusNode myFocusNode = FocusNode();
  GlobalKey<FormState> profileForm = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> updateProfileImage() async {
    var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    File imageFile = File(pickedImage!.path);
    try {
      String imageFileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profilePic": await MultipartFile.fromFile(imageFile.path,
            filename: imageFileName),
      });
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String? authToken = _preferences.getString("TOKEN");
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
  //TODO set iniState and dispose methods

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
      ),
    );
  }

  Widget _labelText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
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

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    } else if (!RegExp(
            r'^(?:254|\+254|0)?(7(?:(?:[129][0–9])|(?:0[0–8])|(4[0–1]))[0–9]{6})$')
        .hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    this.initializeState();
    double height = MediaQuery.of(context).size.height;
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
                              '$BASE_URL/api/v1/uploads/${widget.profile?.profilePic}',
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
                Form(
                  key: profileForm,
                  //TODO insert form key
                  child: Container(
                    constraints: BoxConstraints(minHeight: height - 250),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Personal Information',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(child: _labelText("First Name")),
                                Expanded(child: _labelText("Last Name")),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Enter First Name"),
                                    enabled: !_status,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                    controller: _firstNameController,
                                  ),
                                ),
                                Flexible(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter Last Name",
                                    ),
                                    enabled: !_status,
                                    controller: _lastNameController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[_labelText('Email ')],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: "Enter Email"),
                                    enabled: !_status,
                                    controller: _emailController,
                                    validator: MultiValidator(
                                      [
                                        RequiredValidator(
                                            errorText: "Required"),
                                        EmailValidator(
                                            errorText:
                                                "Please a provide valid email"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[_labelText("Mobile")],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: "Enter Mobile Number",
                                    ),
                                    enabled: !_status,
                                    validator:
                                        phoneValidator, //TODO: insert own phone validator
                                    controller: _phoneNumberController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Palette.primary,
          size: 25.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
