import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';

import 'deleteUser.dart';

//tab view code which is not working

class DeleteUserTabs extends StatefulWidget {
  
  @override
  _WorkApproveModTabsState createState() => _WorkApproveModTabsState();
}

class _WorkApproveModTabsState extends State<DeleteUserTabs>
    with SingleTickerProviderStateMixin {

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
        Tab(text: "Delete Workers"),
        Tab(
          text: "Delete Supervisors",
        ),
        
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
     // appBar: ThemeAppbar("Approve Work", context),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _getTabBar(),
            Container(
              height: MediaQuery.of(context).size.height - 130,
              child: _getTabBarView(
                <Widget>[
                 DeleteUserPage(userType:workerType,collectionName:"workers"),
                DeleteUserPage(userType:supervisorType,collectionName:"supervisor"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
