import 'package:flutter/material.dart';

class PeerCounselorsTab extends StatelessWidget {
  const PeerCounselorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(),
            ),
          );
  }
}
