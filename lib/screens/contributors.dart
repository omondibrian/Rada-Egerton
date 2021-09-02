import 'package:flutter/material.dart';

class ContributorScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        // impliment the revert button to prev screen
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: Row(
          // TODO: Design the images and add list tiles of the contributors
          children: [
            Image.asset('assets/bell.svg'),
            Image.asset('assets/bell.svg'),
            Image.asset('assets/bell.svg'),
          ],
        ),
      ),
    );
  }
}