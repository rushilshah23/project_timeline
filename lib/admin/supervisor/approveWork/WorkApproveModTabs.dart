import 'package:flutter/material.dart';


import '../../CommonWidgets.dart';
import 'WorkApproveModule.dart';
import 'workerSelectDailyForm.dart';

//tab view code which is not working

class WorkApproveModTabs extends StatefulWidget {
  String name , email,  mobile , password,uid, userType,assignedProject;
  WorkApproveModTabs({Key key, this.name, this.email, this.mobile, this.assignedProject, this.userType, this.uid}) : super(key: key);
  @override
  _WorkApproveModTabsState createState() => _WorkApproveModTabsState();
}

class _WorkApproveModTabsState extends State<WorkApproveModTabs> with SingleTickerProviderStateMixin{


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
        Tab(text: "Approve",),
        Tab(text: "Update Work"),
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
      appBar:  ThemeAppbar("Approve Work"),

      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _getTabBar(),
            Container(
              height: MediaQuery.of(context).size.height-130,
              child: _getTabBarView(
                <Widget>[
                  ApproveWork(name: widget.name,email: widget.email, uid: widget.uid,
                    assignedProject: widget.assignedProject,mobile: widget.mobile,userType: widget.userType,),
                  SpecialWorkerFormPage(name: widget.name,email: widget.email, uid: widget.uid,
                    assignedProject: widget.assignedProject,mobile: widget.mobile,userType: widget.userType,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}