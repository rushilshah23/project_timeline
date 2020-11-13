import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/pathnavigator.dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/home/drive.dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/home/shared.dart';

import 'package:project_timeline/admin/ProgressTimeLine/ProgressPage.dart';
import 'package:project_timeline/admin/deleteUsers/deleteUsersTabs.dart';

import 'package:project_timeline/admin/reportGeneration/reportTest.dart';
import 'package:provider/provider.dart';
import '../CommonWidgets.dart';
import '../dashboard.dart';
import '../profile.dart';
import 'CreateAcceptSupervisor/createAcceptSupervisor.dart';
import 'createNewProject/projects.dart';
import 'master/machineMaster/machineMaster.dart';
import 'master/petrolMaster/petrolMaster.dart';

class ManagerHomePage extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  ManagerHomePage(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
  @override
  State createState() => ManagerHomePageState();
}

class ManagerHomePageState extends State<ManagerHomePage> {
  int _selectedDrawerIndex = 0;
  String appbartitle = "Dashboard";

  String name = '',
      lname = '',
      email = '',
      mobile = '',
      password = '',
      uid = '',
      userType = '',
      assignedProject = '';
  _loadData() async {
    setState(() {
      email = widget.email ?? "";
      name = widget.name ?? "";
      mobile = widget.mobile ?? "";
      uid = widget.uid ?? "";
      userType = widget.userType ?? "";
      assignedProject = widget.assignedProject ?? "";

      print("inside profile=" +
          email +
          name +
          mobile +
          lname +
          assignedProject +
          userType);
    });
  }

  @override
  void initState() {
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
        return new PetrolMaster();

      case 2:
        return new MachineMaster();
      case 3:
        return new CreatedProjects();

      case 4:
        return new ProgressPage();

      case 5:
        return new CreateAcceptSupervisor();

      case 6:
        return new ReportGenerationTesting();

      case 8:
        return new SharedPage();

      case 7:
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

      case 9:
        return new DeleteUserTabs();
      // case 9:
      //   return new DeleteUserPage(userType:workerType,collectionName:"workers");

      //  case 10:
      //   return new DeleteUserPage(userType:supervisorType,collectionName:"supervisor");
      default:
        return new Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return WillPopScope(
        onWillPop: () => onBackPressed(context),
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
                      decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                        colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
//                        begin: Alignment.centerRight,
//                        end: Alignment(-1.0,-2.0)
//                    ), //Gradient
                          gradient: gradients()),
                      accountName: Text("Manager"),
                      accountEmail: Text(email),
                      currentAccountPicture: InkWell(
                        onTap: () {
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
                          Text(" Dashboard")
                        ]),
                        onTap: () {
                          _onSelectItem(0);
                          appbartitle = "Dashboard";
                        }),
                    ExpansionTile(
                      title: Row(children: <Widget>[
                        Icon(Icons.add_box),
                        Text(" Masters")
                      ]),
                      children: <Widget>[
                        ListTile(
                            title: Row(children: <Widget>[
                              Icon(Icons.arrow_right),
                              Text("Petrol Pump")
                            ]),
                            onTap: () {
                              _onSelectItem(1);

                              appbartitle = "Petrol Pump Master";
                            }),
                        ListTile(
                            title: Row(children: <Widget>[
                              Icon(Icons.arrow_right),
                              Text("Machine Master")
                            ]),
                            onTap: () {
                              _onSelectItem(2);

                              appbartitle = "Machine Master";
                            }),
                      ],
                    ),
                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.star),
                          Text(" Create Project")
                        ]),
                        onTap: () {
                          _onSelectItem(3);
                          appbartitle = "Create Project";
                        }),
                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.trending_up),
                          Text(" Progress Updates")
                        ]),
                        onTap: () {
                          _onSelectItem(4);
                          appbartitle = " Progress Updates";
                        }),

                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.people),
                          Text(" Create/Accept Supervisors")
                        ]),
                        onTap: () {
                          _onSelectItem(5);
                          appbartitle = "Create/Accept Supervisors";
                        }),

                    // ListTile(
                    //     title: Row(children: <Widget>[
                    //       Icon(Icons.import_contacts),
                    //       Text(" Report Generation")
                    //     ]),
                    //     onTap: () {
                    //       _onSelectItem(6);
                    //       appbartitle = " Report Generation";
                    //     }),

                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.description),
                          Text(" My Documents")
                        ]),
                        onTap: () {
                          _onSelectItem(7);
                          appbartitle = "My Documents";
                        }),

                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.description),
                          Text(" Shared With Me")
                        ]),
                        onTap: () {
                          _onSelectItem(8);
                          appbartitle = "Shared With Me";
                        }),

                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.delete),
                          Text(" Delete Users")
                        ]),
                        onTap: () {
                          // _onSelectItem(9);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeleteUserTabs()),
                          );
                          appbartitle = "Delete Users";
                        }),

                    //   ListTile(
                    // title: Row(children: <Widget>[
                    //   Icon(Icons.delete),
                    //   Text(" Delete Supervisors")
                    // ]),
                    // onTap: () {
                    //   _onSelectItem(10);
                    //   appbartitle = "Delete Supervisors";
                    // }),
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
