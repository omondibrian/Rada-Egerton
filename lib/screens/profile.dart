import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  Widget textField(@required String hintTextfield) {
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

  Widget textLabel(@required String text) {
    return Text(text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700));
  }

  Widget textValue(@required String text) {
    return Text(text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.green,
        ));
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
                        image: AssetImage('assets/egerton.png'),
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
                          icon: Icon(Icons.camera_alt, color: Colors.black),
                          onPressed: null),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text('ROBINSON',
              style: TextStyle(
                fontSize: 25,
                color: Colors.blue,
                fontWeight: FontWeight.w400,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10, right: 25),
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
                textValue('Male')
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
            child: TextField(
              controller: TextEditingController()..text = "ROBINSON",
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
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18))),
                // TODO: create the update password function
                onPressed: () {},
                child: Center(child: Text("Change password"))),
          ),
        ],
      ),
    );
  }
}