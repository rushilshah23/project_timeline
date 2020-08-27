
import 'package:flutter/material.dart';

import 'ViewAllProjects/ViewAllProjects.dart';

// void main() {
//   runApp(MaterialApp(
//     home: ProgressPage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class ProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 120,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PROJECTS',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ViewAllProjects(),
          ),
        ],
      ),
    );
  }
}
