import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/pathnavigator.dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/home/drive.dart';
import 'package:project_timeline/admin/DocumentManager/wrapper.dart';
import 'package:provider/provider.dart';

import '../CommonWidgets.dart';
import 'createAcceptWorker/createAcceptWorker.dart';

import 'package:project_timeline/admin/MasterDataSet/ourMachines.dart';
import 'package:project_timeline/admin/MasterDataSet/ourPetrolPump.dart';
import 'package:project_timeline/admin/ProgressTimeLine/ProgressPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard.dart';
import 'AllocatedProjects.dart';
import 'approveWork/WorkApproveModule.dart';

class SupervisorHomePage extends StatefulWidget {
  @override
  State createState() => SupervisorHomePageState();
}

class SupervisorHomePageState extends State<SupervisorHomePage> {
  int _selectedDrawerIndex = 0;
  String appbartitle = "Dashboard";

  String name = '',
      lname = '',
      email = '',
      mobile = '',
      password = '',
      uid = '',
      userType,
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

  _getDrawerItemWidget(int pos, UserModel user) {
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
        return new YourAllocatedProjects(
          name: name,
          email: email,
          uid: uid,
          assignedProject: assignedProject,
          mobile: mobile,
          userType: userType,
        );

      case 5:
        return new CreateAcceptWorker();

      case 6:
        return DrivePage(
          uid: user.uid,
          pid: user.uid,
          folderId: user.uid,
          ref: globalRef
              .reference()
              .child('users')
              .child(user.uid)
              .child('documentManager')
              .reference()
              .path,
          folderName: user.userEmail ?? user.userPhoneNo ?? null,
        );

      default:
        return new Text("Error");
    }
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
            onTap: () async{
              await AuthenticationService().signoutEmailId();
              SharedPreferences _sharedpreferences =
              await SharedPreferences.getInstance();
              _sharedpreferences.clear();
              return Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                    showToast("Logout Successful");
                    return Wrapper();
                  }));
            },
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
      appBar: ThemeAppbar(appbartitle, context),
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
                  accountName: Text("Supervisor"),
                  accountEmail: Text(email),
                  currentAccountPicture: InkWell(
                    onTap: () {
                      print("image clicked");
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
                    Icon(Icons.add_box),
                    Text("Our Resources")
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
                ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.work),
                      Text(" Your Allocated Projects")
                    ]),
                    onTap: () {
                      _onSelectItem(4);
                      appbartitle = "Your Allocated Projects";
                    }),
                ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.people),
                      Text(" Create/Accept Workers")
                    ]),
                    onTap: () {
                      _onSelectItem(5);
                      appbartitle = "Create/Accept Workers";
                    }),
                ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.description),
                      Text(" Document Manager")
                    ]),
                    onTap: () {
                      _onSelectItem(6);
                      appbartitle = "Document Manager";
                    }),
              ],
            ),
          ),
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex, user),
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
