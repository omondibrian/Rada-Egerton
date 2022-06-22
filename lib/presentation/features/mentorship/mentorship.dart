import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';

class Mentorship extends StatelessWidget {
  const Mentorship({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentorship"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Coming soon",
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(
              height: 10,
            ),
            SvgPicture.asset(
              "assets/mentor.svg",
              width: SizeConfig.isTabletWidth ? 300 : 150,
            ),
          ],
        ),
      ),
    );
  }
}
