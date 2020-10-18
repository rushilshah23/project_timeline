import 'package:Aol_docProvider/core/models/usermodel.dart';
import 'package:Aol_docProvider/core/services/pathnavigator.dart';
import 'package:Aol_docProvider/ui/screens/Authentication/authentication.dart';
import 'package:Aol_docProvider/ui/screens/home/drive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return DrivePage(
        uid: user.uid,
        pid: user.uid,
        folderId: user.uid,
        ref: globalRef
            .reference()
            .child('users')
            .child(user.uid)
            .child('documentManager')
            .reference()
            .path,
        folderName: user.userEmail,
      );
    }
  }
}
