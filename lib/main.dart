import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:provider/provider.dart';
import 'UserSide/Dashboard/Widgets/BottomNav.dart';
import 'admin/manager/createNewProject/test.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Geocoding geocoding = Geocoder.local;

  final Map<String, Geocoding> modes = {
    "Local": Geocoder.local,
    "Google (distant)": Geocoder.google("<API-KEY>"),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppState(
      mode: this.geocoding,
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return StreamProvider<UserModel>.value(
            value: AuthenticationService().user,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: BottomNav(),
            ),
          );
        },
      ),
    );
  }
}

