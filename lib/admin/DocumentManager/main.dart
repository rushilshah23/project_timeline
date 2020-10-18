import 'package:Aol_docProvider/core/models/usermodel.dart';
import 'package:Aol_docProvider/core/services/authenticationService.dart';
import 'package:Aol_docProvider/DocumentManager/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthenticationService().user,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Document Manager",
          home: Wrapper()),
    );
  }
}
