import 'package:flutter/material.dart';

class Mentorship extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mentorship"),
      ),
      body: Container(
        child: Center(
          child: Text(
            "Comming soon",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
