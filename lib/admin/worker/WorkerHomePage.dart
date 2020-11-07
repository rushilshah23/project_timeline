import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/admin/DocumentManager/wrapper.dart';
import 'package:project_timeline/admin/MasterDataSet/ourMachines.dart';
import 'package:project_timeline/admin/MasterDataSet/ourPetrolPump.dart';
import 'package:project_timeline/admin/ProgressTimeLine/ProgressPage.dart';
import 'package:project_timeline/admin/dashboard.dart';
import 'package:project_timeline/admin/headings.dart';
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
  String appbartitle = workerText[8];

  String name = '',
      lname = '',
      email = '',
      mobile = '',
      password = '',
      uid = '',
      userType = '',
      assignedProject='';
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

 

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashBoard(
          name: name,
          email: email,
          uid: uid,
          assignedProject: assignedProject,
          mobile: mobile,
          userType: workerType,
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
    
      default:
        return new Text(workerText2[24]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () =>  onBackPressed(context),
        child: Scaffold(
         
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
                      accountName: Text(workerText2[25]),
                      accountEmail: Text(email),
                      currentAccountPicture: InkWell(
                        onTap: () {
                          print("image clicked");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      uid: uid,
                                      userType: userType,
                                    )),
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
                          Text(workerText[8])
                        ]),
                        onTap: () {
                          _onSelectItem(0);
                          appbartitle = workerText[8];
                        }),
                    ExpansionTile(
                      title: Row(children: <Widget>[
                        Icon(Icons.check_circle),
                        Text(workerText2[25])
                      ]),
                      children: <Widget>[
                        ListTile(
                            title: Row(children: <Widget>[
                              Icon(Icons.arrow_right),
                              Text(workerText2[26])
                            ]),
                            onTap: () {
                              _onSelectItem(1);

                              appbartitle = workerText2[26];
                            }),
                        ListTile(
                            title: Row(children: <Widget>[
                              Icon(Icons.arrow_right),
                              Text(workerText2[27])
                            ]),
                            onTap: () {
                              _onSelectItem(2);

                              appbartitle = workerText2[27];
                            }),
                      ],
                    ),
                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.grade),
                          Text(workerText2[28])
                        ]),
                        onTap: () {
                          _onSelectItem(3);
                          appbartitle = workerText2[28];
                        }),
                    assignedProject.contains(" ") ||
                            assignedProject.contains(workerText2[29])
                        ? Container()
                        : ListTile(
                            title: Row(children: <Widget>[
                              Icon(Icons.work),
                              Text(workerText[7])
                            ]),
                            onTap: () {
                             // _onSelectItem(4);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateWork(
                                          name: name,
                                          email: email,
                                          uid: uid,
                                          assignedProject: assignedProject,
                                          mobile: mobile,
                                          userType: userType,
                                        )),
                              );
                              //appbartitle = "Update Your Work";
                            }),
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
