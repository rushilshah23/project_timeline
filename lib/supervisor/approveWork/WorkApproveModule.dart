import 'package:flutter/material.dart';
import 'TodaysWorks.dart';
import 'file:///C:/Users/User/Desktop/flutter/project_timeline/lib/supervisor/approveWork/AllWork.dart';


class SupervisorTaskModule extends StatefulWidget {
  @override
  _SupervisorTaskModuleState createState() => _SupervisorTaskModuleState();
}

class _SupervisorTaskModuleState extends State<SupervisorTaskModule> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(child: Text('All')),
                Tab(child: Text('Today\'s ')),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              AllTasksSupervisor(),
              TodaysTaskSupervisor(),
            ],
          ),
        ),
      ),
    );
  }
}
