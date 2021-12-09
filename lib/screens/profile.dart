import 'package:flutter/material.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/widgets/ProfileHeader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rada_egerton/widgets/RadaButton.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserDTO? _user;

  AuthServiceProvider _authService = AuthServiceProvider();
  Future<void> init() async {
    final results = await _authService.getProfile();
    results!.fold((user) {
      _user = user;
      _lastNameController.text = _user!.userName;
      _phoneNumberController.text = _user!.phone;

      setState(() {});
    }, (r) => print(r));
  }

  void _updateUserProfile() async {
    if (profileForm.currentState!.validate()) {
      final result = await _authService.updateProfile(UserDTO(
          id: _user!.id,
          name: _lastNameController.text,
          email: _user!.email,
          profilePic: _user!.profilePic,
          gender: _user!.gender,
          phone: _phoneNumberController.text,
          dob: _user!.dob,
          status: _user!.status,
          accountStatus: _user!.accountStatus,
          synced: _user!.synced,
          joined: _user!.joined));
      result.fold((user) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Profile updated",
          style: TextStyle(color: Theme.of(context).primaryColor),
        )));
        isEditing = false;
        setState(() {});
      }, (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          error.message,
          style: TextStyle(color: Theme.of(context).errorColor),
        )));
      });
    }
  }

  bool isEditing = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  GlobalKey<FormState> profileForm = GlobalKey<FormState>();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  @override
  void dispose() {
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    userNameFocus.dispose();

    super.dispose();
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
      body: _user == null
          ? Text('loading')
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    avatarUrl: "$IMAGE_URL${_user!.profilePic}",
                    coverImage: AssetImage('assets/android-icon-192x192.png'),
                    title: "${_user!.userName}", //TODO: fetch username

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
                              isEditing = !isEditing;
                              if (isEditing) {
                                userNameFocus.requestFocus();
                              }
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
                              key: profileForm,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter userName",
                                    ),
                                    enabled: isEditing,
                                    autofocus: true,
                                    focusNode: userNameFocus,
                                    controller: _lastNameController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter phone number",
                                    ),
                                    enabled: isEditing,
                                    controller: _phoneNumberController,
                                    validator: RequiredValidator(
                                        errorText: "Required"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.account_box_outlined),
                                    title: Text("Account status"),
                                    subtitle: Text(
                                        "${_user!.accountStatus}"), //TODO fetch user account status
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.email_outlined),
                                    title: Text("Email"),
                                    subtitle: Text(
                                        "${_user!.email}"), //TODO fetch the date the user joined
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.calendar_today),
                                    title: Text("Date of Birth"),
                                    subtitle: Text(
                                        "${_user!.dob}"), //TODO fetch the date the user joined
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text("Gender"),
                                    subtitle: Text(
                                        "${_user!.gender}"), //TODO fetch the date the user joined
                                  ),
                                  if (isEditing)
                                    Container(
                                        child: Row(
                                      children: [
                                        Expanded(
                                            child: RadaButton(
                                          fill: true,
                                          handleClick: _updateUserProfile,
                                          title: "Save",
                                        )),
                                        Expanded(
                                            child: RadaButton(
                                          fill: false,
                                          handleClick: () => setState(() {
                                            isEditing = false;
                                          }),
                                          title: "Cancel",
                                        ))
                                      ],
                                    )),
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
