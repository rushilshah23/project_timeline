import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_timeline/MasterDataSet/ourMachines.dart';
import 'package:project_timeline/MasterDataSet/ourPetrolPump.dart';
import 'package:project_timeline/ProgressTimeLine/ProgressPage.dart';
import 'package:project_timeline/manager/CreateAcceptSupervisor/createAcceptSupervisor.dart';
import 'package:project_timeline/worker/updateWork.dart';
import 'package:project_timeline/worker/workerDaily.dart';
import 'package:project_timeline/worker/workerForm.dart';

import '../dashboard.dart';



class WorkerHomePage extends StatefulWidget {
  @override
  State createState() => WorkerHomePageState();
}

class WorkerHomePageState extends State<WorkerHomePage> {

  int _selectedDrawerIndex = 0;
  String appbartitle = "Dashboard";

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
    print(index);
    // Navigator.pop(context);
  }


  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashBoard();

      case 1:
        return new OurPetrolPumps();

      case 2:
        return new OurMachines();

      case 3:
        return new ProgressPage();

      case 4:
        return new UpdateWork();





      default:
        return new Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.orange[800],
        ),
        title:  Text(appbartitle, style: TextStyle(
          color: Colors.orange[800],
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
                    gradient: LinearGradient(
                        colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0,-2.0)
                    ), //Gradient
                  ),
                  accountName: Text("worker"),
                  accountEmail: Text("worker1@gmail.com"),
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
                  Row(children: <Widget>[Icon(Icons.check_circle), Text(" Our Resources")]),
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
                      Text(" Update Your Work")
                    ]),
                    onTap: () {
                      _onSelectItem(4);
                      appbartitle = "Update Your Work";
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
    );
  }
}
