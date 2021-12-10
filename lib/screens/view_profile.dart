import 'package:flutter/material.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/widgets/ProfileHeader.dart';

// ignore: must_be_immutable
class ViewProfileScreen extends StatefulWidget {
  String userId;
  ViewProfileScreen(this.userId);
  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  UserDTO? _user;

  AuthServiceProvider _authService = AuthServiceProvider();
  Future<void> init() async {
    final results = await _authService.getStudentProfile(widget.userId);
    results!.fold((user) {
      _user = user;
      setState(() {});
    }, (r) => print(r));
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _user == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    avatarUrl: "$IMAGE_URL${_user!.profilePic}",
                    coverImage: AssetImage('assets/android-icon-192x192.png'),
                    title: "${_user!.userName}",
                    canEdit:false,
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
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  enabled: false,
                                  autofocus: true,
                                  initialValue: _user!.userName,
                                ),
                                TextFormField(
                                  enabled: false,
                                  initialValue: _user!.phone,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
