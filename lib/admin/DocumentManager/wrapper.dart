import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/login.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      // call back login screen of proj_timapp
      return LoginPage();
    } else
      Container();

    // else {
    //   return DrivePage(
    //     uid: user.uid,
    //     pid: user.uid,
    //     folderId: user.uid,
    //     ref: globalRef
    //         .reference()
    //         .child('users')
    //         .child(user.uid)
    //         .child('documentManager')
    //         .reference()
    //         .path,
    //     folderName: user.userEmail ?? user.userPhoneNo ?? null,
    //   );
    // }
  }
}
