import 'package:flutter/material.dart';

class ContributorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Contributors'),
        // impliment the revert button to prev screen
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(child: Image.asset('assets/unesco.png')),
                Expanded(child: Image.asset('assets/srhr.png')),
                Expanded(child: Image.asset('assets/egerton.png')),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: ListTile.divideTiles(context: context, tiles: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Expanded(
                  child: ListTile(
                    title: Text('Name: Brian'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Expanded(
                  child: ListTile(
                    title: Text('Name: Moses'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Expanded(
                  child: ListTile(
                    title: Text('Name: Jonathan'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Expanded(
                  child: ListTile(
                    title: Text('Name: Onesmus'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Expanded(
                  child: ListTile(
                    title: Text('Name: Said'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
              ),
            ]).toList(),
          )),
        ],
      ),
    );
  }
}