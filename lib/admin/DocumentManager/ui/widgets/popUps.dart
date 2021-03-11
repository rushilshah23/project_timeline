import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/filemodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/foldermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/coverters.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/database.dart';
import 'package:project_timeline/admin/DocumentManager/ui/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference supervisors =
    FirebaseFirestore.instance.collection("supervisor");
final CollectionReference managers =
    FirebaseFirestore.instance.collection("manager");

List<int> selectedUsers = [];
List<DropdownMenuItem> dropdwnItems = [];
List<UsersList> usersList = [];

List<String> emailList = [];
Future<void> getData() async {
  await supervisors.get().then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      usersList.add(UsersList(
          name: element['name'],
          mobile: element['mobile'],
          email: element.data().containsKey("email") ? element['email'] : "",
          uid: element['uid']));
    });
  });
  await managers.get().then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      usersList.add(UsersList(
          name: element['name'],
          mobile: element['mobile'],
          email: element.data().containsKey("email") ? element['email'] : "",
          uid: element['uid']));
    });
  });

  usersList.forEach((result) {
    dropdwnItems.add(
      DropdownMenuItem(
        child: Container(
            //color: color,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.name),
                Text(
                  result.email.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  result.mobile,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            )),
        value: result.name,
      ),
    );
  });
}

shareWithPopUp(
  BuildContext context, {
  FocusNode focusNode,
  FolderModel folderModel,
  FileModel fileModel,
  String documentSenderId,
  documentType documentType,
}) async {
  await getData();
  TextEditingController _sharerControllerName = new TextEditingController();
  GlobalKey<FormState> _sharerKeyName = new GlobalKey<FormState>();
  return showDialog(
    context: context,
    builder: (context) {
      UserModel _userModel = Provider.of<UserModel>(context);
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
            "Enter emailId or phone No. starting with +91 of the person to give access of the document and seperate by comma, to share with multiple users"),
        content: Form(
          key: _sharerKeyName,
          // child: TextFormField(
          //   cursorColor: Color(0xFF02DEED),
          //   style: TextStyle(
          //     color: Colors.black,
          //   ),
          //   decoration: InputDecoration(
          //     filled: true,
          //     fillColor: Colors.grey[300],
          //     labelStyle: TextStyle(
          //         color: focusNode.hasFocus ? Colors.black : Color(0xFF02DEED),
          //         fontSize: 10.0),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: Colors.grey[500],
          //       ),
          //     ),
          //     focusedBorder: UnderlineInputBorder(
          //       borderSide: BorderSide(color: Color(0xFF02DEED)),
          //     ),
          //   ),
          //   focusNode: focusNode,
          //   autofocus: true,
          //   controller: _sharerControllerName,
          //   validator: null,
          //   // validator: emailValidator

          //   // validator: passwordValidator,
          // ),

          child: SearchableDropdown.multiple(
            items: dropdwnItems,
            selectedItems: selectedUsers,
            hint: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Select Supervisors"),
            ),
            searchHint: "Select any",
            onChanged: (value) {
              selectedUsers = value;

              selectedUsers.forEach((element) {
                debugPrint(usersList[element].uid.toString());
              });
            },
            closeButton: (selectedItems) {
              // emailList = selectedItems;
              return (selectedItems.isNotEmpty
                  ? "Save ${selectedItems.length == 1 ? '"' + dropdwnItems[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                  : "Save without selection");
            },
            isExpanded: true,
          ),
        ),
        actions: [
          FlatButton(
              onPressed: () {
                _sharerControllerName.clear();
                Navigator.of(context).pop();
                selectedUsers.clear();
                usersList.clear();
                dropdwnItems.clear();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
          FlatButton(
              color: Colors.white,
              onPressed: () async {
                selectedUsers.forEach((element) {
                  if (usersList[element].email != "") {
                    emailList.add(usersList[element].email.toString());
                  } else {
                    emailList.add(usersList[element].mobile.toString());
                  }
                });

                // emailList = getEmailList(_sharerControllerName.text);
                // emailList = getEmailList(emailList.toString());

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
                  emailList.clear();
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

class UsersList {
  UsersList({Key key, this.name, this.mobile, this.uid, this.email});
  var name;
  var mobile, email;
  var uid;
}
