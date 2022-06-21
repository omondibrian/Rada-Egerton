import 'package:flutter/material.dart';
import 'package:rada_egerton/resources/theme.dart';
import '../sizeConfig.dart';

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
      width: SizeConfig.isTabletWidth ? 600 : 290.0,
      height: SizeConfig.isTabletWidth ? 50 : 40.0,
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Palette.accent,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(5),
          border: fill
              ? Border.all(color: Colors.transparent)
              : Border.all(color: Theme.of(context).primaryColor)),
      child: TextButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(
            Size(290.0, 50.0),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            TextStyle(color: Colors.white),
          ),
          backgroundColor: fill
              ? MaterialStateProperty.all<Color>(Colors.transparent)
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
              ? TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.isTabletWidth ? 18 : 16,
                )
              : TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.isTabletWidth ? 18 : 16,
                ),
        ),
      ),
    );
  }
}
