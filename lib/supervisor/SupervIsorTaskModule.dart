import 'package:flutter/material.dart';
import 'package:project_timeline/supervisor/AllTasksSupervisor.dart';
import 'package:project_timeline/supervisor/TodaysTaskSupervisor.dart';

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
                Tab(child: Text('All Tasks')),
                Tab(child: Text('Today\'s tasks')),
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
