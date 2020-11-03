import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/AboutUs/Pages/AboutAOLMain.dart';
import 'package:project_timeline/UserSide/AboutUs/Pages/AboutDevelopersMain.dart';
import 'package:project_timeline/UserSide/AboutUs/Pages/AboutIAHVMain.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State createState() => new HomeWidgetState();
}

class HomeWidgetState extends State with SingleTickerProviderStateMixin {
  final List<Widget> tabs = [
    new Tab(
      text: "About AOL",
    ),
    new Tab(
      text: "About IAHV",
    ),
    new Tab(
      text: "About SAKEC",
    )
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: commonBGColor,
      appBar: AppBar(
       iconTheme: IconThemeData(
      color: Color(0xff005c9d),
      ),
      title: Text("About Us",
          style: TextStyle(
            color: Color(0xff005c9d),
          )),
      backgroundColor: Colors.white ,
        bottom: TabBar(
          unselectedLabelColor: bubbleindicatorColor,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 35.0,
            indicatorColor: bubbleindicatorColor,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          // indicatorColor: Colors.blueAccent,
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: new TabBarView(controller: _tabController, children: <Widget>[
        MainAOLPage(),
        MainIAHVPage(),
        MainDevelopersPage(),
      ]),
    );
  }
}
