import 'package:flutter/material.dart';

class ContributorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        // impliment the revert button to prev screen
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        
      ),
      body: Stack(
        children: [
          Row(
            children: [
               Image.asset(''),
               Image.asset(''),
               Image.asset(''),
              ],
          ),
          Column(
            children: const <Widget>[
                Expanded(
                  child:ListTile(
                    title: Text('Brian'),
                    subtitle: Text('Software developer'),
                    //isThreeLine: Text(),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Moses'),
                    subtitle: Text('Software developer'),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Jonathan'),
                    subtitle: Text('Software developer'),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Onesmus'),
                    subtitle: Text('Software developer'),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Said'),
                    subtitle: Text('Software developer'),
                  ),
                ),
            ]
          )
        ],
      ),
    );
  }
}
