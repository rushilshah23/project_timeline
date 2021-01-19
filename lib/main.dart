import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/multilingual/app_localizations.dart';
import 'package:project_timeline/multilingual/dynamic_translation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UserSide/Dashboard/Widgets/BottomNav.dart';
import 'admin/manager/createNewProject/test.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';

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
  final Geocoding geocoding = Geocoder.local;

  final Map<String, Geocoding> modes = {
    "Local": Geocoder.local,
    "Google (distant)": Geocoder.google("<API-KEY>"),
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AppState(
      mode: this.geocoding,
      child: StreamProvider<UserModel>.value(
        value: AuthenticationService().user,
        child: MaterialApp(
          // supportedLocales: [
          //   Locale('en', 'US'),
          //   Locale('hi', 'IN'),
          //   Locale('mr', 'IN'),
          // ],
          // localizationsDelegates: [
          //   AppLocalizations.delegate,
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          // ],
          // localeResolutionCallback: (locale, supportedLocales) {
          //   for (var supportedLocale in supportedLocales) {
          //     if (supportedLocale.languageCode == locale.languageCode &&
          //         supportedLocale.countryCode == locale.countryCode) {
          //       return supportedLocale;
          //     }
          //   }
          //   return supportedLocales.first;
          // },
          debugShowCheckedModeBanner: false,
          title: 'IAHV',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: BottomNav(),
        ),
      ),
      //   },
      // ),
    );
  }
}
