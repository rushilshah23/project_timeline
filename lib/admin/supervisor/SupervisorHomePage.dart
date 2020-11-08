import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/pathnavigator.dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/home/drive.dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/home/shared.dart';
import 'package:project_timeline/admin/DocumentManager/wrapper.dart';
import 'package:project_timeline/admin/headings.dart';
import 'package:project_timeline/admin/login.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../CommonWidgets.dart';
import '../profile.dart';
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
  String appbartitle = superText[0];

  String name = '',
      lname = '',
      email = '',
      mobile = '',
      password = '',
      uid = '',
      userType='',
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

  _getDrawerItemWidget(int pos, UserModel user) {
    switch (pos) {
      case 0:
        return new DashBoard(
          name: name,
          email: email,
          uid: uid,
          assignedProject: assignedProject,
          mobile: mobile,
          userType: supervisorType,
        );

      case 1:
        return new OurPetrolPumps();

      case 2:
        return new OurMachines();

      case 3:
        return new ProgressPage();

      case 4:
        return new YourAllocatedProjects(
          name: name.toString(),
          email: email.toString(),
          uid: uid.toString(),
          assignedProject: assignedProject.toString(),
          mobile: mobile.toString(),
          userType: userType.toString(),
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

        case 7:
        return new SharedPage();
      default:
        return new Text(superText[1]);
    }
  }



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    return WillPopScope(
        onWillPop: () =>  onBackPressed(context),
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
                  accountName: Text(superText5[16]),
                  accountEmail: Text(email),
                  currentAccountPicture: InkWell(
                    onTap: () {
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
                      Text(superText[0])
                    ]),
                    onTap: () {
                      _onSelectItem(0);
                      appbartitle = superText[0];
                    }),
                ExpansionTile(
                  title: Row(children: <Widget>[
                    Icon(Icons.add_box),
                    Text(superText[2])
                  ]),
                  children: <Widget>[
                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.arrow_right),
                          Text(superText[3])
                        ]),
                        onTap: () {
                          _onSelectItem(1);

                          appbartitle = superText[3];
                        }),
                    ListTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.arrow_right),
                          Text(superText[4])
                        ]),
                        onTap: () {
                          _onSelectItem(2);

                          appbartitle = superText[4];
                        }),
                  ],
                ),
                ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.grade),
                      Text(superText[5])
                    ]),
                    onTap: () {
                      _onSelectItem(3);
                      appbartitle = superText[5];
                    }),

                     assignedProject.contains(" ")||assignedProject.contains("No project assigned")?Container(): 
                      ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.work),
                      Text(superText[6])
                    ]),
                    onTap: () {
                      _onSelectItem(4);
                      appbartitle = superText[6];
                    }),
             
                ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.people),
                      Text(superText[7])
                    ]),
                    onTap: () {
                      _onSelectItem(5);
                      appbartitle = superText[7];
                    }),
                 ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.description),
                      Text(superText[8])
                    ]),
                    onTap: () {
                      _onSelectItem(6);
                      appbartitle = superText[8];
                    }),

                      ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.description),
                      Text(superText[9])
                    ]),
                    onTap: () {
                      _onSelectItem(7);
                      appbartitle = superText[9];
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
