import 'package:flutter/material.dart';
import 'SupervisorFormCreation.dart';
import 'SupervisorRequestList.dart';

//tab view code which is not working

class CreateAcceptSupervisor extends StatefulWidget {
  @override
  _CreateAcceptSupervisorState createState() => _CreateAcceptSupervisorState();
}

class _CreateAcceptSupervisorState extends State<CreateAcceptSupervisor> with SingleTickerProviderStateMixin{


//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: DefaultTabController(
//        length: 2,
//        child: Scaffold(
//          appBar: new PreferredSize(
//            preferredSize: Size.fromHeight(kToolbarHeight),
//            child: new Container(
//              color: Colors.orange,
//              child: new SafeArea(
//                child: Column(
//                  children: <Widget>[
//                    new Expanded(child: new Container()),
//                     TabBar(
//
//                      tabs: [
//                        Tab(text: "Update",),
//                        Tab(text: "Approvals"),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ),
//
//          body: TabBarView(
//            children: [
//              WorkerForm(),
//              WorkerDaily(),
//            ],
//          ),
//        ),
//      ),
//    );
//  }


  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar _getTabBar() {
    return TabBar(
      labelColor: Colors.blue,
      tabs: <Widget>[
        Tab(text: "Create",),
        Tab(text: "Accept"),
      ],
      controller: tabController,
    );
  }

  TabBarView _getTabBarView(tabs) {
    return TabBarView(
      children: tabs,

      controller: tabController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _getTabBar(),
            Container(
              height: MediaQuery.of(context).size.height-130,
              child: _getTabBarView(
                <Widget>[
                  SupervisorFormCreation(),
                  SupervisorRequestList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}