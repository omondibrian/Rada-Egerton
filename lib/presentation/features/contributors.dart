import 'package:flutter/material.dart';

class ContributorScreen extends StatelessWidget {
  const ContributorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Contributors'),
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
          ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: ListTile(
                    title: Text('Name: Brian'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: ListTile(
                    title: Text('Name: Moses'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: ListTile(
                      title: Text('Name: Jonathan'),
                      subtitle: Text(
                          'University: Egerton \nRole: Software developer'),
                    )),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: ListTile(
                    title: Text('Name: Onesmus'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: ListTile(
                    title: Text('Name: Said'),
                    subtitle:
                        Text('University: Egerton \nRole: Software developer'),
                  ),
                ),
              ],
            ).toList(),
          ),
        ],
      ),
    );
  }
}
