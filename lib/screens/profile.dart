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

class ProfilePage extends StatefulWidget {
  // static final String path = "lib/src/pages/profile/profile8.dart";

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  late UserDTO? userProfile = UserDTO();
}

class _ProfilePageState extends State<ProfilePage> {
  //get user profile
  Future<void> getUserProfile() async {
    AuthServiceProvider _authService = AuthServiceProvider();
    final authServceResults = await _authService.getProfile();

    setState(() {
      widget.userProfile = authServceResults;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfile();
  }

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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                avatar: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'),
                coverImage: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80'),
                title: "User Name",//TODO: fetch username
                
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 0,
                    child: Icon(Icons.edit),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              UserInfo(),
            ],
          ),
        ));
  }
}

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Theme.of(context).primaryColor,
                        tiles: [
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Email"),
                            subtitle: Text("sudeptech@gmail.com"),//TODO fetch user email
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Phone"),
                            subtitle: Text("99--99876-56"),//TODO fetch user phone number
                          ),
                          ListTile(
                            leading: Icon(Icons.my_location),
                            title: Text("Gender"),
                            subtitle: Text("Kathmandu"),//TODO fetch user gender
                          ),ListTile(
                            leading: Icon(Icons.my_location),
                            title: Text("Gender"),
                            subtitle: Text("Kathmandu"),//TODO fetch user date of birth
                          ),ListTile(
                            leading: Icon(Icons.my_location),
                            title: Text("Gender"),
                            subtitle: Text("Kathmandu"),//TODO fetch user date joined
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text("About Me"),//  TODO: fetch user account status
                            subtitle: Text(
                                "This is a about me link and you can khow about me in this section."),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
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
            image: DecorationImage(
                image: coverImage as ImageProvider<Object>, fit: BoxFit.cover),
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
                radius: 40,
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
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image as ImageProvider<Object>?,
        ),
      ),
    );
  }
}



// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rada_egerton/services/auth/main.dart';
// import 'package:rada_egerton/services/constants.dart';
// import 'package:rada_egerton/theme.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../sizeConfig.dart';

// // ignore: must_be_immutable
// class ProfileScreen extends StatefulWidget {
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
//   late UserDTO? profile = UserDTO();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool _status = true;
//   Dio _httpConnection = Dio();
//   final FocusNode myFocusNode = FocusNode();
//   GlobalKey<FormState> profileForm = GlobalKey<FormState>();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _firstNameController = TextEditingController();
//   TextEditingController _genderController = TextEditingController();
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _dateOfBirthController = TextEditingController();

//   final ImagePicker _imagePicker = ImagePicker();

//   Future<void> updateProfileImage() async {
//     var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
//     File imageFile = File(pickedImage!.path);
//     try {
//       String imageFileName = imageFile.path.split('/').last;
//       FormData formData = FormData.fromMap({
//         "profilePic": await MultipartFile.fromFile(imageFile.path,
//             filename: imageFileName),
//       });
//       SharedPreferences _preferences = await SharedPreferences.getInstance();
//       String? authToken = _preferences.getString("TOKEN");
//       await _httpConnection.put(
//         '$BASE_URL/api/v1/admin/user/profile',
//         data: formData,
//         options: Options(
//           headers: {
//             'Authorization': authToken,
//             "Content-type": "multipart/form-data",
//           },
//         ),
//       );
//     } catch (e) {
//       //TODO:remove error specification statement
//       print('Error from updateProfile : $e');
//     }
//   }
//   //TODO set iniState and dispose methods

//   Future<void> initializeState() async {
//     AuthServiceProvider _authService = AuthServiceProvider();
//     final results = await _authService.getProfile();
//     // print(results);
//     if (results!.id.isNotEmpty) {
//       setState(() {
//         widget.profile = results;
//       });
//     }
//   }

//   // Widget textField(String hintTextfield) {
//   //   return Material(
//   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //     child: TextField(
//   //       controller: TextEditingController()..text = hintTextfield,
//   //       decoration: InputDecoration(
//   //         hintText: "Username",
//   //         hintStyle: TextStyle(
//   //           letterSpacing: 2,
//   //           color: Colors.black54,
//   //         ),
//   //         fillColor: Colors.black12,
//   //         filled: true,
//   //         border: OutlineInputBorder(
//   //           borderSide: BorderSide.none,
//   //           borderRadius: BorderRadius.circular(10.0),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _labelText(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     );
//   }

//   Widget textValue(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 18,
//         color: Colors.green,
//       ),
//     );
//   }

//   String? phoneValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'This value is required';
//     } else if (!RegExp(
//             r'^(?:254|\+254|0)?(7(?:(?:[129][0–9])|(?:0[0–8])|(4[0–1]))[0–9]{6})$')
//         .hasMatch(value)) {
//       return 'Please enter a valid phone number';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     this.initializeState();
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         title: Text('Profile'),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//       ),
//       body: widget.profile == null
//           ? Center(
//               child: SizedBox(
//                 width: 80,
//                 height: 80,
//                 child:
//                     SpinKitSpinningLines(color: Theme.of(context).primaryColor),
//               ),
//             )
//           : Column(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 40.0),
//                     child: Stack(
//                       children: [
//                         CachedNetworkImage(
//                           imageUrl:
//                               '$BASE_URL/api/v1/uploads/${widget.profile?.profilePic}',
//                           imageBuilder: (context, imageProvider) => Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               image: DecorationImage(
//                                 image: imageProvider,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             width: SizeConfig.isTabletWidth ? 150 : 120,
//                             height: SizeConfig.isTabletWidth ? 150 : 120,
//                           ),
//                           placeholder: (context, url) => SpinKitFadingCircle(
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                         Positioned(
//                           left: 80,
//                           top: 80,
//                           child: CircleAvatar(
//                             backgroundColor: Colors.white,
//                             child: IconButton(
//                               icon: Icon(Icons.camera_alt, color: Colors.black),
//                               onPressed: () {
//                                 updateProfileImage();
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Form(
//                   key: profileForm,
//                   //TODO insert form key
//                   child: Container(
//                     constraints: BoxConstraints(minHeight: height - 250),
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.secondary,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 25.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     Text(
//                                       'Personal Information',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18.0,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     _status ? _getEditIcon() : Container(),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 25.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Expanded(
//                                   child: _labelText("Name"),
//                                 ),
//                                 Expanded(
//                                   child: _labelText("Gender"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 2.0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Flexible(
//                                   child: TextFormField(
//                                     decoration: InputDecoration(
//                                         hintText: "Enter your name"),
//                                     enabled: !_status,
//                                     validator: RequiredValidator(
//                                         errorText: "Required"),
//                                     controller: _firstNameController,
//                                   ),
//                                 ),
//                                 Flexible(
//                                   child: TextFormField(
//                                     decoration: InputDecoration(
//                                       hintText: "Enter your Gender",
//                                     ),
//                                     enabled: !_status,
//                                     controller: _genderController,
//                                     validator: RequiredValidator(
//                                         errorText: "Required"),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 25.0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[_labelText('Email ')],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 2.0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Flexible(
//                                   child: TextFormField(
//                                     decoration: const InputDecoration(
//                                         hintText: "Enter Email"),
//                                     enabled: !_status,
//                                     controller: _emailController,
//                                     validator: MultiValidator(
//                                       [
//                                         RequiredValidator(
//                                             errorText: "Required"),
//                                         EmailValidator(
//                                             errorText:
//                                                 "Please a provide valid email"),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 25.0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     _labelText('Date Of Birth ')
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 2.0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Flexible(
//                                   child: TextFormField(
//                                     decoration: const InputDecoration(
//                                         hintText: "Enter date of birth"),
//                                     //TODO insert date picker
//                                     enabled: !_status,
//                                     controller: _dateOfBirthController,
//                                     validator: MultiValidator(
//                                       [
//                                         RequiredValidator(
//                                             errorText: "Required"),
//                                         EmailValidator(
//                                             errorText:
//                                                 "Please enter a valid date"),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 25.0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[_labelText("Mobile")],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: 25.0, right: 25.0, top: 2.0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Flexible(
//                                   child: TextFormField(
//                                     decoration: const InputDecoration(
//                                       hintText: "Enter Mobile Number",
//                                     ),
//                                     enabled: !_status,
//                                     validator:
//                                         phoneValidator, //TODO: insert own phone validator
//                                     controller: _phoneNumberController,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _getEditIcon() {
//     return GestureDetector(
//       child: CircleAvatar(
//         backgroundColor: Colors.white,
//         radius: 14.0,
//         child: Icon(
//           Icons.edit,
//           color: Palette.primary,
//           size: 25.0,
//         ),
//       ),
//       onTap: () {
//         setState(
//           () {
//             _status = false;
//           },
//         );
//       },
//     );
//   }
// }
