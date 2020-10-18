import 'package:flutter/material.dart';

import 'package:project_timeline/admin/ProgressTimeLine/ProgressPage.dart';
import 'package:project_timeline/admin/reportGeneration/ReportGeneration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CommonWidgets.dart';
import '../dashboard.dart';
import 'CreateAcceptSupervisor/createAcceptSupervisor.dart';
import 'createNewProject/projects.dart';
import 'master/machineMaster/machineMaster.dart';
import 'master/petrolMaster/petrolMaster.dart';



class ManagerHomePage extends StatefulWidget {
  @override
  State createState() => ManagerHomePageState();
}

class ManagerHomePageState extends State<ManagerHomePage> {

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
        return new ReportGeneration();


      default:
        return new Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppbar(appbartitle),

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
                  gradient: gradients()
                  ),
                  accountName: Text("Manager"),
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
                  Row(children: <Widget>[Icon(Icons.add_box), Text(" Masters")]),
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
                      Text(" Our Projects")
                    ]),
                    onTap: () {
                      _onSelectItem(3);
                      appbartitle = "Our Projects";
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

                ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.import_contacts),
                      Text(" Report Generation")
                    ]),
                    onTap: () {
                      _onSelectItem(6);
                      appbartitle = " Report Generation";
                    }),

                ListTile(
                    title: Row(children: <Widget>[
                      Icon(Icons.description),
                      Text(" Document Manager")
                    ]),
                    onTap: () {
                      _onSelectItem(5);
                      appbartitle = "Create/Accept Supervisors";
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
