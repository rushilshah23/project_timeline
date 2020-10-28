import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';

import 'workerDaily.dart';
import 'workerForm.dart';

//tab view code which is not working

class UpdateWork extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  UpdateWork(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
  @override
  _UpdateWorkState createState() => _UpdateWorkState();
}

class _UpdateWorkState extends State<UpdateWork>
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
      labelColor: Color(0xff005c9d),
      tabs: <Widget>[
        Tab(
          text: "Update",
        ),
        Tab(text: "Approvals"),
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
      appBar: ThemeAppbar("Update Your Work", context),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _getTabBar(),
            Container(
              height: MediaQuery.of(context).size.height - 130,
              child: _getTabBarView(
                <Widget>[
                  WorkerFormPage(
                    name: widget.name,
                    email: widget.email,
                    uid: widget.uid,
                    assignedProject: widget.assignedProject,
                    mobile: widget.mobile,
                    userType: widget.userType,
                  ),
                  WorkerDaily(
                    name: widget.name,
                    email: widget.email,
                    uid: widget.uid,
                    assignedProject: widget.assignedProject,
                    mobile: widget.mobile,
                    userType: widget.userType,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
