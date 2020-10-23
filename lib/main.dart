// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
// import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
// import 'package:provider/provider.dart';
// import 'UserSide/Dashboard/Widgets/BottomNav.dart';
// import 'admin/dashboard.dart';
// import 'admin/login.dart';
// import 'admin/manager/createNewProject/projects.dart';
// import 'admin/manager/createNewProject/test.dart';
// import 'admin/reportGeneration/reportTest.dart';
// import 'admin/supervisor/approveWork/WorkApproveModule.dart';
// import 'admin/supervisor/approveWork/workerSelectDailyForm.dart';
// import 'admin/worker/workerForm.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoder/services/base.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   Geocoding geocoding = Geocoder.local;

//   final Map<String, Geocoding> modes = {
//     "Local": Geocoder.local,
//     "Google (distant)": Geocoder.google("<API-KEY>"),
//   };

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return AppState(
//       mode: this.geocoding,
//       child: FutureBuilder(
//         future: Firebase.initializeApp(),
//         builder: (context, snapshot) {
//           return StreamProvider<UserModel>.value(
//             value: AuthenticationService().user,
//             child: MaterialApp(
//               title: 'Flutter Demo',
//               theme: ThemeData(
//                 primarySwatch: Colors.blue,
//                 visualDensity: VisualDensity.adaptivePlatformDensity,
//               ),
//               home: BottomNav(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: ListView(
//           children: <Widget>[
//             RaisedButton(
//               child: Text("PDF testing"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ReportGenerationTesting()),
//                 );
//               },
//             ),

//             RaisedButton(
//               child: Text("Projects"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CreatedProjects()),
//                 );
//               },
//             ),
//             RaisedButton(
//               child: Text("Add New Project"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Test()),
//                 );
//               },
//             ),
//             RaisedButton(
//               child: Text("Dashboard"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DashBoard()),
//                 );
//               },
//             ),
//             // RaisedButton(
//             //   child: Text("Machine Master"),
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => MachineMaster()),
//             //     );
//             //   },
//             // ),
//             RaisedButton(
//               child: Text("Supervisor Section"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ApproveWork()),
//                 );
//               },
//             ),
//             // RaisedButton(
//             //   child: Text("Petrol Module"),
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => PetrolMaster()),
//             //     );
//             //   },
//             // ),
//             RaisedButton(
//               child: Text("Login"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                 );
//               },
//             ),
//             RaisedButton(
//               child: Text("Search Worker"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => SpecialWorkerFormPage()),
//                 );
//               },
//             ),
//             // RaisedButton(
//             //   child: Text("Supervisor Rquest"),
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //           builder: (context) => SupervisorRequestList()),
//             //     );
//             //   },
//             // ),
//             // RaisedButton(
//             //   child: Text("Worker Request"),
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => WorkerRequestList()),
//             //     );
//             //   },
//             // ),
//             // RaisedButton(
//             //   child: Text("Worker Form- Supervisor can create himself"),
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => WorkerCreationForm()),
//             //     );
//             //   },
//             // ),
//             // RaisedButton(
//             //   child: Text("Supervisor Form- Manager can create himself"),
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //           builder: (context) => SupervisorFormCreation()),
//             //     );
//             //   },
//             // ),
//             RaisedButton(
//               child: Text("Worker Form"),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => WorkerFormPage()),
//                 );
//               },
//             ),
//             // RaisedButton(
//             //   child: Text("Worker Daily Updates"),
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => WorkerDaily()),
//             //     );
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/Dashboard/Widgets/BottomNav.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DashBoard',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNav(),
    );
  }
}
