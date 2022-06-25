import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/presentation/widgets/profile_header.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/data/services/auth_service.dart';

class ViewProfileScreen extends StatefulWidget {
  final String userId;
  const ViewProfileScreen(this.userId,{Key? key}):super(key: key);
  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  User? _user;

  Future<void> init() async {
    final results = await AuthService.getStudentProfile(widget.userId);
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
                    coverImage: const AssetImage('assets/android-icon-192x192.png'),
                    title: _user!.name,
                    canEdit: false,
                  ),
                  const SizedBox(height: 10.0),
                  // UserInfo(),

                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          alignment: Alignment.topLeft,
                          child: const Text(
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
                            padding: const EdgeInsets.all(15),
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
                                  leading: const Icon(Icons.account_box_outlined),
                                  title: const Text("Account status"),
                                  subtitle: Text("${_user!.accountStatus}"),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.email_outlined),
                                  title: const Text("Email"),
                                  subtitle: Text(_user!.email),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: const Text("Date of Birth"),
                                  subtitle: Text("${_user!.dob}"),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text("Gender"),
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
