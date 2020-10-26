import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/admin/DocumentManager/wrapper.dart';
import 'package:project_timeline/admin/MasterDataSet/ourMachines.dart';
import 'package:project_timeline/admin/MasterDataSet/ourPetrolPump.dart';
import 'package:project_timeline/admin/ProgressTimeLine/ProgressPage.dart';
import 'package:project_timeline/admin/dashboard.dart';
import 'package:project_timeline/admin/deleteUser.dart';
import 'package:project_timeline/admin/login.dart';
import 'package:project_timeline/admin/worker/updateWork.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../profile.dart';

class WorkerHomePage extends StatefulWidget {
  @override
  State createState() => WorkerHomePageState();
}

class WorkerHomePageState extends State<WorkerHomePage> {
  int _selectedDrawerIndex = 0;
  String appbartitle = "Dashboard";

  String name = '',
      lname = '',
      email = '',
      mobile = '',
      password = '',
      uid = '',
      userType='',
      assignedProject;
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      email = (prefs.getString('email') ?? '');
      name = (prefs.getString('name') ?? '');
      mobile = (prefs.getString('mobile') ?? '');
      uid = (prefs.getString('uid') ?? '');
      userType = (prefs.getString('userType') ?? '');
      assignedProject = (prefs.getString('assignedProject') ?? '');
      print(
          "inside profile=" + email + name + mobile + lname + assignedProject);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
    print(index);
    // Navigator.pop(context);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () async {
                  await AuthenticationService().signoutEmailId();
                  SharedPreferences _sharedpreferences =
                      await SharedPreferences.getInstance();
                  _sharedpreferences.clear();
                  Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return MyApp();
              },),
              (Route route) => false);
                },
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashBoard(
          name: name,
          email: email,
          uid: uid,
          assignedProject: assignedProject,
          mobile: mobile,
          userType: userType,
        );

      case 1:
        return new OurPetrolPumps();

      case 2:
        return new OurMachines();

      case 3:
        return new ProgressPage();

      case 4:
        return new UpdateWork(
          name: name,
          email: email,
          uid: uid,
          assignedProject: assignedProject,
          mobile: mobile,
          userType: userType,
        );
      case 5:
        return new DeleteUserPage(
          name: name,
          email: email,
          uid: uid,
          assignedProject: assignedProject,
          mobile: mobile,
          userType: userType,
        );

      default:
        return new Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          // appBar: new AppBar(
          //   iconTheme: IconThemeData(
          //     color: Color(0xff005c9d),
          //   ),
          //   title: Text(appbartitle,
          //       style: TextStyle(
          //         color: Color(0xff005c9d),
          //       )),
          //   backgroundColor: Colors.white,
          // ),
          appBar: ThemeAppbar(appbartitle, context),

          drawer: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: new Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(gradient: gradients()),
                      accountName: Text("Worker"),
                      accountEmail: Text(email),
                      currentAccountPicture: InkWell(
                        onTap: () {
                          print("image clicked");

                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(uid: uid,userType: userType,)),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            "M",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.home),
                          Text(" Dashboard")
                        ]),
                        onTap: () {
                          _onSelectItem(0);
                          appbartitle = "Dashboard";
                        }),
                    ExpansionTile(
                      title: Row(children: <Widget>[
                        Icon(Icons.check_circle),
                        Text(" Our Resources")
                      ]),
                      children: <Widget>[
                        ListTile(
                            title: Row(children: <Widget>[
                              Icon(Icons.arrow_right),
                              Text("Our Petrol Pump")
                            ]),
                            onTap: () {
                              _onSelectItem(1);

                              appbartitle = "Our Petrol Pumps";
                            }),
                        ListTile(
                            title: Row(children: <Widget>[
                              Icon(Icons.arrow_right),
                              Text("Our Machines")
                            ]),
                            onTap: () {
                              _onSelectItem(2);

                              appbartitle = "Our Machines";
                            }),
                      ],
                    ),
                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.grade),
                          Text(" Our Projects")
                        ]),
                        onTap: () {
                          _onSelectItem(3);
                          appbartitle = "Our Projects";
                        }),
                    if (assignedProject != "No project assigned" ||
                        assignedProject != '' ||
                        assignedProject != null)
                      ListTile(
                          title: Row(children: <Widget>[
                            Icon(Icons.work),
                            Text(" Update Your Work")
                          ]),
                          onTap: () {
                            _onSelectItem(4);
                            appbartitle = "Update Your Work";
                          }),
                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.work),
                          Text("Delete User")
                        ]),
                        onTap: () {
                          _onSelectItem(5);
                          appbartitle = "Delete User";
                        }),

//                ListTile(
//                    title: Row(children: <Widget>[
//                      Icon(Icons.people),
//                      Text(" Create/Accept Supervisors")
//                    ]),
//                    onTap: () {
//                      _onSelectItem(5);
//                      appbartitle = "Create/Accept Supervisors";
//                    }),
                  ],
                ),
              ),
            ),
          ),
          body: _getDrawerItemWidget(_selectedDrawerIndex),
//      body: Center(
//
//        child: Column(
//
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              "You're logged in as a Manager\n",
//            ),
//            Text("Your UID is 8YiMHLBnBaNjmr3yPvk8NWvNPmm2 "),
//          ],
//        ),
//      ),
        ));
  }
}
