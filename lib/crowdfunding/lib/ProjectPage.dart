import 'package:AOL_localfeedback/ApiRazorPay.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProjectPage extends StatefulWidget {
  MyProjectPageState createState() => MyProjectPageState();
}

class MyProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: new Column(
          children: <Widget>[
            Container(
              height: 300,
              child: Carousel(
                autoplay: true,
                showIndicator: true,
                indicatorBgPadding: 0.1,
                boxFit: BoxFit.cover,
                images: [
                  Image.asset("image/AOL_LOGO.png"),
                  Image.network("https://miro.medium.com/max/759/1*3f5QqcQR9KK8c1AwVH-sPg.jpeg"),
                  Image.network("https://pbs.twimg.com/media/EDOcP15W4AEhdrS.jpg"),
                  Image.network("https://www.insightsonindia.com/wp-content/uploads/2017/06/water-conservation.jpg"),
                  Image.network("https://www.artofliving.org/sites/www.artofliving.org/files/water-conservation-project-page-800.jpg"),
                ],
                //showIndicator: true,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            progress,
            text,
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ApiRazorPay()));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Color(0xFFFF8F00),
                            const Color(0xFFFFc107)
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.edit),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Donate now',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget progress = Container(
  height: 180,
  padding: const EdgeInsets.all(20),
  child: new Center(
    child: Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  '25',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Projects \nOngoing',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  '25',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Projects\n  Done',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);
// #About
Widget text = Container(
  padding: const EdgeInsets.all(20),
  child: new Center(
    child: new Column(
      children: <Widget>[
        Text(
          'Giving is the greatest act of grace.',
          softWrap: true,
          style: TextStyle(
            fontFamily: 'DancingScript',
            color: Colors.black,
            fontSize: 29,
          ),
        )
      ],
    ),
  ),
);