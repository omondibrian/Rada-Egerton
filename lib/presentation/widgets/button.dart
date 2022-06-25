import 'package:flutter/material.dart';
import 'package:rada_egerton/resources/size_config.dart';
import 'package:rada_egerton/resources/theme.dart';

class RadaButton extends StatelessWidget {
  final String title;
  final void Function() handleClick;
  final bool fill;
  const RadaButton({
    Key? key,
    required this.title,
    required this.handleClick,
    required this.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.isTabletWidth ? 600 : 290.0,
      height: 50,
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.all(8.0),
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
            const Size(290.0, 50.0),
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
        onPressed: handleClick,
        child: Text(
          title,
          style: fill
              ? const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                )
              : const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
        ),
      ),
    );
  }
}

class RadaButtonProgress extends StatelessWidget {
  final String title;
  final bool fill;
  const RadaButtonProgress({
    Key? key,
    required this.title,
    this.fill = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.isTabletWidth ? 600 : 290.0,
      height: 50.0,
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.all(8.0),
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
        onPressed: () {},
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(290.0, 50.0),
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
        child: fill
            ? Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const CircularProgressIndicator(
                    color: Colors.white,
                  )
                ],
              )
            : Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const CircularProgressIndicator(
                    color: Colors.black,
                  )
                ],
              ),
      ),
    );
  }
}
