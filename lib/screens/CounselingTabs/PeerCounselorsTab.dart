import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PeerCounselorsTab extends StatelessWidget {
  const PeerCounselorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitSpinningLines(
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.headline1,
          )
        ],
      ),
    );
  }
}
