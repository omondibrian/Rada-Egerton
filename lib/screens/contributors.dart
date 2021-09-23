import 'package:flutter/material.dart';

class ContributorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        // impliment the revert button to prev screen
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Image.asset('assets/unesco.png')),
              Expanded(
                child: Image.asset('assets/srhr.png')),
              Expanded(
                child: Image.asset('assets/egerton.png')),
            ],
          ),
          Column(children: const <Widget>[
            Expanded(
              child: ListTile(
                title: Text('Brian Omondi'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
                //isThreeLine: Text(),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('Moses Njoroge'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('Jonathan Onderi'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('Name: Onesmus Okali'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('Said Mohammed'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
