import 'package:flutter/material.dart';

class RadaButton extends StatelessWidget {
  final String title;
  final void Function() handleClick;
  final bool fill;
  RadaButton(
      {Key? key,
      required this.title,
      required this.handleClick,
      required this.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290.0,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Theme.of(context).primaryColor)),
      child: TextButton(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(color: Colors.white)),
          backgroundColor: fill
              ? MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)
              : MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        onPressed: this.handleClick,
        child: Text(
          this.title,
          style: fill
              ? TextStyle(color: Colors.white)
              : TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
