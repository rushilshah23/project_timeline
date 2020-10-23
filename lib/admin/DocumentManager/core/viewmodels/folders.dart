import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/foldermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/database.dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/home/drive.dart';
import 'package:project_timeline/admin/DocumentManager/ui/shared/constants.dart';
import 'package:project_timeline/admin/DocumentManager/ui/widgets/popUps.dart';
import 'package:provider/provider.dart';

class FolderCard extends StatefulWidget {
  final FolderModel folderModel;
  final dynamic documentSenderId;

  FolderCard({
    @required this.folderModel,
    this.documentSenderId,
  });
  @override
  _FolderCardState createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  TextEditingController _renameFolderController = new TextEditingController();

  GlobalKey<FormState> _renameFolderKey = new GlobalKey<FormState>();
  var userModelVar;
  FirebaseDatabase _folderDatabase = FirebaseDatabase.instance;
  DatabaseReference _folderRef;
  String _folderRefPath;

  final _focusNode = FocusNode();

  void initState() {
    _folderRef = _folderDatabase
        .reference()
        .child(widget.folderModel.globalRef)
        .child('inFolders')
        .reference();
    // .child(widget.folderModel.folderId);
    // .reference();

    _folderRefPath = _folderRef.path;
    // widget.folderModel.globalRef.reference().child(widget.folderModel.folderId)
    userModelVar = Provider.of<UserModel>(context, listen: false);
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _renameFolderController.selection = TextSelection(
            baseOffset: 0, extentOffset: _renameFolderController.text.length);
      }
    });
  }

  deleteFolderPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Delete Folder?"),
            content: Text('Are you sure you want to delete this folder?'),
            actions: [
              FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black))),
              FlatButton(
                  color: Colors.white,
                  onPressed: () async {
                    DatabaseService(

                            // globalRef:
                            //     widget.globalRef.child(widget.folderId),
                            userID: widget.documentSenderId ??
                                widget.folderModel.userId)
                        .deleteFolder(
                      folderId: widget.folderModel.folderId,
                      driveRef: _folderRef,
                      // widget.folderModel.globalRef,

                      // folderName: widget.folderName,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        });
  }

  renameFolderPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Rename Folder"),
          content: Form(
            key: _renameFolderKey,
            child: TextFormField(
                cursorColor: Color(0xFF02DEED),
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: TextStyle(
                      color: _focusNode.hasFocus
                          ? Colors.black
                          : Color(0xFF02DEED),
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
                focusNode: _focusNode,
                autofocus: true,
                controller: _renameFolderController,
                validator: (String content) {
                  if (content.length != 0) {
                    if (content.contains("#") ||
                        content.contains("[") ||
                        content.contains("]") ||
                        content.contains("*") ||
                        content.contains("/") ||
                        content.contains("?")) {
                      return "enter valid folder name";
                      // "Folder name should not contains invalid characters like #,[,],*,?";
                    } else
                      return null;
                  } else
                    return "Enter new filename";
                }),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  _renameFolderController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                )),
            FlatButton(
                color: Colors.white,
                onPressed: () async {
                  if (_renameFolderKey.currentState.validate()) {
                    DatabaseService(
                            userID: widget.documentSenderId ??
                                widget.folderModel.userId)
                        .renameFolder(
                            folderId: widget.folderModel.folderId,
                            newFolderName: _renameFolderController.text,
                            driveRef:
                                // widget.folderModel.globalRef);
                                _folderRef);
                    _renameFolderController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Rename",
                  style: TextStyle(color: Color(0xFF02DEED)),
                )),
          ],
        );
      },
    );
  }

  void folderOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    topRight: const Radius.circular(30),
                  )),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.black),
                    title: Text("Delete Folder"),
                    onTap: () async {
                      Navigator.pop(context);
                      deleteFolderPopUp(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.label, color: Colors.black),
                    title: Text("Rename Folder"),
                    onTap: () {
                      Navigator.pop(context);
                      renameFolderPopUp(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.share, color: Colors.black),
                    title: Text("Share"),
                    onTap: () {
                      shareWithPopUp(
                        context,
                        documentSenderId: widget.documentSenderId,
                        documentType: documentType.folder,
                        folderModel: widget.folderModel,
                        focusNode: _focusNode,
                      );
                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<UserModel>(context);
    return Container(
        height: 120,
        width: 120,
        // color: Colors.red,
        child: FittedBox(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  iconSize: 60,
                  // constraints: BoxConstraints.tight(Size.fromRadius(40)),
                  icon: Icon(
                    Icons.folder,
                    size: 70,
                  ),
                  color: cardColor,
                  onPressed: () {
                    _folderRef = _folderRef
                        // .child('inFolders')
                        //     .child(widget.folderModel.folderId)
                        .reference();

                    _folderRefPath = _folderRef.path;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DrivePage(
                        pid: widget.folderModel.parentId,
                        uid: widget.folderModel.userId,
                        folderId: widget.folderModel.folderId,
                        ref: _folderRefPath,
                        // ref: widget.folderModel.globalRef,

                        folderName: widget.folderModel.folderName,
                      );
                    }));
                    // folder pressed
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 3),
                  width: 70,
                  padding: EdgeInsets.only(left: 13),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 120,
                          child: AutoSizeText(
                            "${widget.folderModel.folderName}",
                            maxLines: 2,
                            minFontSize: 28,
                            maxFontSize: 28,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 5),
                        IconButton(
                            icon: FaIcon(FontAwesomeIcons.ellipsisV),
                            onPressed: () {
                              folderOptions(context);
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
