import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/Dashboard/Pages/myHomePage.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/ProgressTimeLine/ProgressPage.dart';
import 'package:project_timeline/admin/login.dart';
import 'package:project_timeline/admin/manager/ManagerHomePage.dart';
import 'package:project_timeline/admin/supervisor/SupervisorHomePage.dart';
import 'package:project_timeline/admin/worker/WorkerHomePage.dart';
import 'package:project_timeline/crowdfunding/ApiRazorPay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool isLoggedIn = false;
  String userType;
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  SharedPreferences sharedPreferences;
  String language;

  void initState() {
    //print("in homepage");
    // _languageHome = context.read<Language>();
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = (prefs.getBool('isLoggedIn') ?? false);
      userType = (prefs.getString('userType') ?? '');
    });
  }

  void goToHomePage() {
    if (userType == managerType) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ManagerHomePage()),
      );
    }
    if (userType == workerType) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerHomePage()),
      );
    }
    if (userType == supervisorType) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SupervisorHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: withoutLogoutAppbar(
          context: context,
          goto: goToHomePage,
          isLoggedIn: isLoggedIn,
          title: "IAHV",
        ),
        // AppBar(
        //   iconTheme: IconThemeData(
        //     color: Color(0xff005c9d),
        //   ),
        //   title: Text("IAHV",
        //       style: TextStyle(
        //         color: Color(0xff005c9d),
        //       )),
        //   backgroundColor: Colors.white,
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(
        //         Icons.person,
        //       ),
        //       onPressed: () {
        //         // do something
        //         isLoggedIn==false?Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => LoginPage()),
        //         ):goToHomePage();
        //       },
        //     )
        //   ],
        // ),
        body: getPage(currentPage),
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: bottomnavColor,
          activeIconColor: iconColor,
          inactiveIconColor: bottomnavColor,
          tabs: [
            TabData(
                iconData: Icons.home,
                title: "Home",
                onclick: () {
                  final FancyBottomNavigationState fState =
                      bottomNavigationKey.currentState;
                  fState.setPage(0);
                }),
            TabData(
                iconData: Icons.assignment,
                title: "Projects",
                onclick: () {
                  final FancyBottomNavigationState fState =
                      bottomNavigationKey.currentState;
                  fState.setPage(1);
                }),
            TabData(
                iconData: Icons.attach_money,
                title: "Donations",
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
