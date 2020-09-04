
import 'package:flutter/material.dart';

import 'ViewAllProjects/ViewAllProjects.dart';

// void main() {
//   runApp(MaterialApp(
//     home: ProgressPage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 70,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Our Projects',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: AllProjects(),
          ),
        ],
      ),
    );
  }
}
