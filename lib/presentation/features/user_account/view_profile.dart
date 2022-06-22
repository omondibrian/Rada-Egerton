import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/presentation/widgets/ProfileHeader.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/data/services/auth/main.dart';

class ViewProfileScreen extends StatefulWidget {
  final String userId;
  ViewProfileScreen(this.userId);
  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  User? _user;

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
                    avatarUrl: imageUrl(_user!.profilePic),
                    coverImage: AssetImage('assets/android-icon-192x192.png'),
                    title: "${_user!.name}",
                    canEdit: false,
                  ),
                  const SizedBox(height: 10.0),
                  // UserInfo(),

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
                                  initialValue: _user!.name,
                                ),
                                TextFormField(
                                  enabled: false,
                                  initialValue: _user!.phone,
                                ),
                                ListTile(
                                  leading: Icon(Icons.account_box_outlined),
                                  title: Text("Account status"),
                                  subtitle: Text("${_user!.accountStatus}"),
                                ),
                                ListTile(
                                  leading: Icon(Icons.email_outlined),
                                  title: Text("Email"),
                                  subtitle: Text("${_user!.email}"),
                                ),
                                ListTile(
                                  leading: Icon(Icons.calendar_today),
                                  title: Text("Date of Birth"),
                                  subtitle: Text("${_user!.dob}"),
                                ),
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text("Gender"),
                                  subtitle: Text("${_user!.gender}"),
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