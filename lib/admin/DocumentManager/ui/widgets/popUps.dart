import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/filemodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/foldermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/coverters.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/database.dart';
import 'package:project_timeline/admin/DocumentManager/ui/shared/constants.dart';
import 'package:provider/provider.dart';

shareWithPopUp(
  BuildContext context, {
  FocusNode focusNode,
  FolderModel folderModel,
  FileModel fileModel,
  String documentSenderId,
  documentType documentType,
}) {
  TextEditingController _sharerControllerName = new TextEditingController();
  GlobalKey<FormState> _sharerKeyName = new GlobalKey<FormState>();
  return showDialog(
    context: context,
    builder: (context) {
      UserModel _userModel = Provider.of<UserModel>(context);
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
            "Enter emailId or phone No. of the person to give access of the document and seperate by comma, to share with multiple users"),
        content: Form(
          key: _sharerKeyName,
          child: TextFormField(
            cursorColor: Color(0xFF02DEED),
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelStyle: TextStyle(
                  color: focusNode.hasFocus ? Colors.black : Color(0xFF02DEED),
                  fontSize: 10.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[500],
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF02DEED)),
              ),
            ),
            focusNode: focusNode,
            autofocus: true,
            controller: _sharerControllerName,
            validator: null,
            // validator: emailValidator

            // validator: passwordValidator,
          ),
        ),
        actions: [
          FlatButton(
              onPressed: () {
                _sharerControllerName.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
          FlatButton(
              color: Colors.white,
              onPressed: () async {
                List<String> emailList;
                emailList = getEmailList(_sharerControllerName.text);
                if (_sharerKeyName.currentState.validate()) {
                  await DatabaseService(
                    userID: documentSenderId ?? _userModel.uid,
                  ).shareWith(
                    docType: documentType,
                    receiverEmailId: emailList,
                    // receiverEmailId: _sharerControllerName.text,

                    folderModel: folderModel ?? null,
                    fileModel: fileModel ?? null,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Share",
                style: TextStyle(color: Color(0xFF02DEED)),
              )),
        ],
      );
    },
  );
}
