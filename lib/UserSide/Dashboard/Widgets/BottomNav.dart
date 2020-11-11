import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:project_timeline/UserSide/Dashboard/Pages/myHomePage.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:project_timeline/UserSide/selectLanguage.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/ProgressTimeLine/ProgressPage.dart';
import 'package:project_timeline/admin/login.dart';
import 'package:project_timeline/admin/manager/ManagerHomePage.dart';
import 'package:project_timeline/admin/supervisor/SupervisorHomePage.dart';
import 'package:project_timeline/admin/worker/WorkerHomePage.dart';
import 'package:project_timeline/crowdfunding/ApiRazorPay.dart';
import 'package:project_timeline/languages/rawText/bottomNavText.dart';
import 'package:project_timeline/multilingual/dynamic_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool isLoggedIn = false;
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  SharedPreferences sharedPreferences;
  String language;
  ProgressDialog pr;

  final FirebaseAuth auth = FirebaseAuth.instance;

  String name = '',
      email = '',
      mobile = '',
      uid = '',
      userType = '',
      assignedProject = '';

  List<String> translatedText;

  List l1 = ['garden', 'forest', 'industry', 'trees'];
  String s1 = "garden";
  Map testStringMap = {
    'a': {
      'a1': 'Home',
      'a2': 'School',
      'a3': 'Garden',
    },
    'b': {
      'b1': 'Country',
      'b2': 'World',
      'b3': 'Island',
    },
    'c': {
      'c1': ['cricket', 'badminton', 'volleyball', 'football'],
      'c2': ['trees', 'plants', 'creepers', 'mangroves'],
      'c3': ['elephant', 'kangaroo', 'rabbits', 'eagle'],
    }
  };

  void initState() {
    //print("in homepage");
    // _languageHome = context.read<Language>();
    super.initState();
    _loadData();
    // loadListMapTranslation();
    // loadStringListTranslation();
    DynamicTranslation().stringTranslate(data: s1);
    loadTranslatedText();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = (prefs.getBool('isLoggedIn') ?? false);
      userType = (prefs.getString('userType') ?? '');
    });
  }

  Future<bool> _getUserData(String userType) async {
    bool returnbool = false;

    try {
      await pr.show();
      final userUid = auth.currentUser.uid;
      await FirebaseFirestore.instance
          .collection(userType)
          .doc(userUid)
          .get()
          .then((myDocuments) {
        Map myData = myDocuments.data();

        debugPrint(
            "-----------nnnnnnnnnnnnnn---------------" + myData.toString());
        if (myData != null) {
          setState(() {
            name = myData["name"] ?? "";
            email = myData["email"] ?? "";
            mobile = myData["mobile"] ?? "";
            assignedProject = myData["assignedProject"] ?? "";
            uid = userUid;
          });
          returnbool = true;
        } else {
          returnbool = false;
        }
      });
    } catch (e) {
      returnbool = false;
    }

    await pr.hide();
    if (returnbool == false) showToast("Failed! Check your Internet");
    return returnbool;
  }

  void goToHomePage() async {
    bool status;

    if (userType == managerType) {
      status = await _getUserData("manager");
      debugPrint("--------------------------" + status.toString());
      // if (status == true)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManagerHomePage(
                  name: name,
                  email: email,
                  uid: uid,
                  assignedProject: assignedProject,
                  mobile: mobile,
                  userType: managerType,
                )),
      );
    }
    if (userType == workerType) {
      status = await _getUserData("workers");
      debugPrint("--------------------------" + status.toString());
      //if (status == true)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkerHomePage(
                  name: name,
                  email: email,
                  uid: uid,
                  assignedProject: assignedProject,
                  mobile: mobile,
                  userType: workerType,
                )),
      );
    }
    if (userType == supervisorType) {
      status = await _getUserData("supervisor");

      debugPrint("--------------------------" + status.toString());
<<<<<<< HEAD
      if (status == true)
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SupervisorHomePage(
                    name: name,
                    email: email,
                    uid: uid,
                    assignedProject: assignedProject,
                    mobile: mobile,
                    userType: supervisorType,
                  )),
        );
=======
      // if (status == true)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SupervisorHomePage(
                  name: name,
                  email: email,
                  uid: uid,
                  assignedProject: assignedProject,
                  mobile: mobile,
                  userType: supervisorType,
                )),
      );
>>>>>>> 552589c618c6352cb315c61d6b2744e9611b56e6
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
<<<<<<< HEAD
    }
  }

  loadStringListTranslation() async {
    try {
      var getl1 = await DynamicTranslation().listTranslation(data: l1);
      getl1.forEach((element) {
        debugPrint(element);
      });
    } catch (e) {
      debugPrint("load string from map trnaslation failed " + e.toString());
    }
  }

  loadListMapTranslation() async {
    try {
      debugPrint("----------Original tEXT ----------");
      // debugPrint(testStringMap['a']);
      // debugPrint(testStringMap['b']);
      // debugPrint(testStringMap['c']);

      // testStringMap.forEach((key, value) {
      //   debugPrint(key + " " + value);
      // });
      debugPrint("----------translated text ----------");
      var getMap =
          await DynamicTranslation().mapTranslation(data: testStringMap);
      getMap.forEach((key, value) {
        debugPrint(key + ":" + value);
      });
    } catch (e) {
      debugPrint("not able to translate " + e.toString());
=======
>>>>>>> 552589c618c6352cb315c61d6b2744e9611b56e6
    }
  }

  loadTranslatedText() async {
    try {
      await DynamicTranslation()
          .listtranslate(inputs: bottomNavText)
          .then((value) {
        setState(() {
          translatedText = value;
        });
      });
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xff005c9d),
          ),
          title: Text("IAHV",
              style: TextStyle(
                color: Color(0xff005c9d),
              )),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person,
              ),
              onPressed: () async {
                await _loadData();
                // do something
                isLoggedIn == false
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      )
                    : goToHomePage();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.language_sharp,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectLanguage()),
                );
              },
            )
          ],
        ),
        body: getPage(currentPage),
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: bottomnavColor,
          activeIconColor: iconColor,
          inactiveIconColor: bottomnavColor,
          tabs: [
            TabData(
                iconData: Icons.home,
                // title: "Home",
                title: translatedText[0] ?? "",
                onclick: () {
                  final FancyBottomNavigationState fState =
                      bottomNavigationKey.currentState;
                  fState.setPage(0);
                }),
            TabData(
                iconData: Icons.assignment,
                // title: "Projects",
                title: translatedText[1] ?? "",
                onclick: () {
                  final FancyBottomNavigationState fState =
                      bottomNavigationKey.currentState;
                  fState.setPage(1);
                }),
            TabData(
                iconData: Icons.attach_money,
                // title: "Donations",
                title: translatedText[2] ?? "",
                onclick: () {
                  final FancyBottomNavigationState fState =
                      bottomNavigationKey.currentState;
                  fState.setPage(2);
                }),
          ],
          initialSelection: 0,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ));
  }
}

getPage(int page) {
  switch (page) {
    case 0:
      return MyHome(); //HomePage
    case 1:
      return ProgressPage(); //Add Project Page here
    case 2:
      return ApiRazorPay(null); //Add donation Page here
    default:
      return MyHome();
  }
}
