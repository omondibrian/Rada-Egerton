import 'package:flutter/material.dart';

class ContributorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        // impliment the revert button to prev screen
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
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
                title: Text('Brian'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
                //isThreeLine: Text(),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('Moses'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('Jonathan'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('Name: Onesmus'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('Said'),
                subtitle: Text('University: Egerton \n Role: Software developer'),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
