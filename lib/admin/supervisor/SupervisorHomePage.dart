import 'package:flutter/material.dart';

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



  String name = '', lname = '', email = '', mobile = '', password = '',uid='', userType,assignedProject;
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      email = (prefs.getString('email') ?? '');
      name = (prefs.getString('name') ?? '');
      mobile = (prefs.getString('mobile') ?? '');
      uid = (prefs.getString('uid') ?? '');
      userType = (prefs.getString('userType') ?? '');
      assignedProject = (prefs.getString('assignedProject') ?? '');

      print("inside profile="+email + name + mobile + lname+ assignedProject);


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
        return new DashBoard(name: name,email: email, uid: uid, assignedProject: assignedProject,mobile: mobile,userType: userType,);

      case 1:
        return new OurPetrolPumps();

      case 2:
        return new OurMachines();

      case 3:
        return new ProgressPage();

      case 4:
        return new YourAllocatedProjects(name: name,email: email, uid: uid, assignedProject: assignedProject,mobile: mobile,userType: userType,);


      case 5:
        return new CreateAcceptWorker();



      default:
        return new Text("Error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.indigo[200],
        ),
        title:  Text(appbartitle, style: TextStyle(
          color: Colors.indigo,
        )),
        backgroundColor: Colors.white,
      ),

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
                    gradient: gradients()
                  ),
                  accountName: Text("Supervisor"),
                  accountEmail: Text(email),
                  currentAccountPicture: InkWell(
                    onTap: () {
                      print("image clicked");
                    },
                    child: CircleAvatar(
                      backgroundColor:Colors.white,
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
                  title:
                  Row(children: <Widget>[Icon(Icons.add_box), Text("Our Resources")]),
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
    );
  }
}
