import 'package:flutter/material.dart';
import 'package:project_timeline/admin/headings.dart';
import 'package:project_timeline/admin/supervisor/createAcceptWorker/workerRequestList.dart';

import 'WorkerCreationForm.dart';

//tab view code which is not working

class CreateAcceptWorker extends StatefulWidget {
  @override
  _CreateAcceptWorkerState createState() => _CreateAcceptWorkerState();
}

class _CreateAcceptWorkerState extends State<CreateAcceptWorker> with SingleTickerProviderStateMixin{


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
        Tab(text: superText3[28],),
        Tab(text: superText3[29]),
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
                  WorkerCreationForm(),
                  WorkerRequestList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}