import 'package:flutter/material.dart';
import 'package:rada_egerton/theme.dart';

Widget buildInput() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30.0),
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Button choose image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () {},
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
          //Emoji button
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
                  hintStyle: TextStyle(color: Colors.black,
                  fontSize: 15.0),
                ),
              ),
            ),
          ),
      
          // Button send message
          Material(
            child: Container(
              decoration:BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.accent,
              ),
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
          border: Border(
            top: BorderSide(color: Colors.black87, width: 0.5),
          ),
          color: Colors.white),
    ),
  );
}
