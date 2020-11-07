import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:project_timeline/UserSide/UI/Widgets/cards.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/crowdfunding/userDetailModel.dart';

import 'ApiRazorPay.dart';

// ignore: camel_case_types
class leaderBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return board();
  }
}

// ignore: camel_case_types
class board extends StatefulWidget {
  @override
  _boardState createState() => _boardState();
}

List<UserDetails> userDetailsList = [];
List<UserDetails> newUserDetailsList = [];

// ignore: camel_case_types
class _boardState extends State<board> {
  @override
  void initState() {
    super.initState();
    retriveData();
  }

  retriveData() async {
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference
        .child("Donation")
        .once()
        .then((DataSnapshot snapshot) {
      userDetailsList.clear();
      newUserDetailsList.clear();
      if (snapshot.value != null) {
        try {
          var data = snapshot.value;
          var keys = snapshot.value.keys;
          if (keys != 0) {
            for (var key in keys) {
              setState(() {
                UserDetails userdetails = new UserDetails(
                  name: data[key]['details']['name'],
                  total: data[key]['details']['total'],
                );
                userDetailsList.add(userdetails);
              });
            }
            newUserDetailsList = userDetailsList;
            userDetailsList.sort((a, b) => (b.total).compareTo(a.total));
          }
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: plainAppBar(context: context, title: 'Charity Leader Board'),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 14, 10, 15),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Image.asset(
                          'assets/logo.png',
                          scale: 5,
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Image.asset(
                          'assets/logo2.png',
                          scale: 2,
                        )),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                padding: EdgeInsets.fromLTRB(10, 8, 10, 4),
                child: Text(
                  "The measure of life is not its duration, but its donation.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 27,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: 290,
                  child: Center(
                    child: FlatButton(
                      child: Container(
                        width: 200,
                        height: 50,
                        padding: EdgeInsets.all(15),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff018abd),
                        ),
                        child: Text(
                          "Donate Now",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApiRazorPay(null)));
                      },
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Text(
                "Leader Board",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: ListView(
                  children: [
                    for (var i = 0; i < userDetailsList.length && i < 1; i++)
                      Card(
                        color: HexColor('#e2f3fb'),
                        child: ListTile(
                          leading: Image.asset(
                            "assets/1.png",
                            scale: 2,
                          ),
                          title: Container(
                            child: Text(
                              userDetailsList[i].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          trailing: Container(
                            child: Text(
                              "₹" + userDetailsList[i].total.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    for (var i = 1; i < userDetailsList.length && i < 2; i++)
                      Card(
                        color: HexColor('#e2f3fb'),
                        child: ListTile(
                          leading: Image.asset(
                            "assets/2.png",
                            scale: 2,
                          ),
                          title: Container(
                            child: Text(
                              userDetailsList[i].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          trailing: Container(
                            child: Text(
                              "₹" + userDetailsList[i].total.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    for (var i = 2; i < userDetailsList.length && i < 3; i++)
                      Card(
                        color: HexColor('#e2f3fb'),
                        child: ListTile(
                          leading: Image.asset(
                            "assets/3.png",
                            scale: 2,
                          ),
                          title: Container(
                            child: Text(
                              userDetailsList[i].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          trailing: Container(
                            child: Text(
                              "₹" + userDetailsList[i].total.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    for (var i = 3; i < userDetailsList.length && i < 9; i++)
                      Card(
                        color: HexColor('#e2f3fb'),
                        child: ListTile(
                          leading: Text(
                            "\t\t\t" + (i + 1).toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          title: Container(
                            child: Text(
                              userDetailsList[i].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                          trailing: Container(
                            child: Text(
                              "₹" + userDetailsList[i].total.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
