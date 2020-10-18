import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'CommonWidgets.dart';



class DashBoard extends StatefulWidget {

  String name , email,  mobile , password,uid, userType,assignedProject;
  DashBoard({Key key, this.name, this.email, this.mobile, this.assignedProject, this.userType, this.uid}) : super(key: key);
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  double percent = 10;
  double percent1 = 10;
  double percent2 = 80;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: new AppBar(
//        iconTheme: IconThemeData(
//          color: Colors.orange[800],
//        ),
//        title:  Text('Dashboards', style: TextStyle(
//            color: Colors.orange[800],
//        )),
//        backgroundColor: Colors.white,
//      ),
      body: ListView(
        children: <Widget>[
          _myAppBar2(),
          _body()
        ],
      ),
    );
  }

  Widget _myAppBar2() {
    return Container(
      height: MediaQuery.of(context).size.height/3.5,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
//        gradient: LinearGradient(
//            colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
//            begin: Alignment.centerRight,
//            end: Alignment(-1.0,-2.0)
//        ),// Gradient
      gradient: gradients()
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0,left: 30),
        child: Center(
            child: Column(
              children: [
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child:Icon(
                          Icons.person_pin,
                          color: Colors.white,
                          size: 50,
                        )
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 5,
                      child:Container(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28.0
                              ),
                            ),
                            Text(
                              widget.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            )
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0,left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                        'Projects',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18
                        )
                    ),
                    SizedBox(height: 10),
                    Text(
                        '10',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12
                        )
                    ),
                  ],
                ),
                Container(height: 60, child: VerticalDivider(color: Colors.grey[400],width: 20,thickness: 2,)),
                Column(
                  children: [
                    Text(
                        'Team',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18
                        )
                    ),
                    SizedBox(height: 10),
                    Text(
                        '150',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12
                        )
                    ),
                  ],
                ),
//                Container(height: 60, child: VerticalDivider(color: Colors.grey[400],width: 20,thickness: 2,)),
//                Column(
//                  children: [
//                    Text(
//                        'Donation',
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            color: Colors.grey[600],
//                            fontSize: 18
//                        )
//                    ),
//                    SizedBox(height: 10),
//                    Text(
//                        '123',
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            color: Colors.grey[600],
//                            fontSize: 12
//                        )
//                    ),
//                  ],
//                ),
              ],
            ),
            SizedBox(height: 35),
            Text(
              'Statistics..',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 6.0,
                      animation: true,
                      percent: double.parse(percent.toString())/100,
                      center: new Text(
                        percent.toString()+"%",
                        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.blue[800],
                    ),
                    SizedBox(height: 10),
                    Text(
                        'Completed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 17
                        )
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 6.0,
                      animation: true,
                      percent: double.parse(percent1.toString())/100,
                      center: new Text(
                        percent1.toString()+"%",
                        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.blue[600],
                    ),
                    SizedBox(height: 10),
                    Text(
                        'Ongoing',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 17
                        )
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 6.0,
                      animation: true,
                      percent: double.parse(percent2.toString())/100,
                      center: new Text(
                        percent2.toString()+"%",
                        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.blue[300],
                    ),
                    SizedBox(height: 10),
                    Text(
                        'Not Started',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 17
                        )
                    ),
                  ],
                ),

              ],
            ),
            SizedBox(height: 70),
            Center(
              child: FlatButton(
//                child: Container(
//                  height: 50,
//                  width: double.infinity,
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    gradient: LinearGradient(
//                        colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
//                        begin: Alignment.centerRight,
//                        end: Alignment(-1.0,-2.0)
//                    ), //Gradient
//                  ),
//                  child: Center(
//
//                    child: Text(
//                        'Our Projects',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold
//                      ),
//                    ),
//                  ),
//                ),
              child: buttonContainers(double.infinity, 20, 'Our Projects', 18),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

}