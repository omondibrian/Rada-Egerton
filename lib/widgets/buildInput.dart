import 'package:flutter/material.dart';

Widget buildInput() {
  return Container(
    child: Row(
      children: <Widget>[
        // Button send image
        Material(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
              },
              color: Colors.black,
            ),
          ),
          color: Colors.white,
        ),
        Material(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.face),
              onPressed: () {},
              color: Colors.black,
            ),
          ),
          color: Colors.white,
        ),

        // Edit text
        Flexible(
          child: Container(
            child: TextField(
              onSubmitted: (value) {},
              style: TextStyle(color: Colors.black87, fontSize: 15.0),
              decoration: InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),

        // Button send message
        Material(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {},
            ),
          ),
          color: Colors.white,
        ),
      ],
    ),
    width: double.infinity,
    height: 50.0,
    decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black87, width: 0.5)),
        color: Colors.white),
  );
}
