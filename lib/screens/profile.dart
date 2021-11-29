import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/services/constants.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  late UserDTO profile = UserDTO();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> initializeState() async {
    AuthServiceProvider _authService = AuthServiceProvider();
    final results = await _authService.getProfile();
    results!.fold((l) => setState(() => widget.profile = l), (r) => print(r));
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
                  borderRadius: BorderRadius.circular(10.0))),
        ));
  }

  Widget textLabel(String text) {
    return Text(text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700));
  }

  Widget textValue(String text) {
    return Text(text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.green,
        ));
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
            icon: Icon(Icons.arrow_back)),
      ),
      body: widget.profile.toString().isEmpty
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
                        // image design form here
                        // TODO: add an image in the projo or use the one available
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            image: DecorationImage(
                              image: NetworkImage(
                                  "$BASE_URL/api/v1/uploads/${widget.profile.profilePic}"),
                              //TODO : Cache Network Image
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 80,
                          top: 80,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                                icon:
                                    Icon(Icons.camera_alt, color: Colors.black),
                                onPressed: null),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(widget.profile.userName,
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
                      textValue(widget.profile.gender),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 20, right: 20, bottom: 20),
                  child: TextField(
                    controller: TextEditingController()
                      ..text = widget.profile.userName,
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
