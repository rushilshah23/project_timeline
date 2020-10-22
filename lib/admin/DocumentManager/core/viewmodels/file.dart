import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/filemodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/database.dart';
import 'package:project_timeline/admin/DocumentManager/ui/shared/constants.dart';
import 'package:project_timeline/admin/DocumentManager/ui/widgets/popUps.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FileCard extends StatefulWidget {
  final FileModel fileModel;
  final dynamic documentSenderId;

  FileCard({
    this.fileModel,
    this.documentSenderId,
  });
  @override
  _FileCardState createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  TextEditingController _renameFileController = new TextEditingController();
  GlobalKey<FormState> _renameFileKey = new GlobalKey<FormState>();
  final _focusNode = FocusNode();

  var userModelVar;
  FirebaseDatabase _folderDatabase = FirebaseDatabase.instance;
  DatabaseReference _folderRef;
  // String _folderRefPath;

  void initState() {
    _folderRef = _folderDatabase
        .reference()
        .child(widget.fileModel.globalRef)
        .child('inFolders')
        .reference();
    // .child(widget.fileModel.fileId);

    // _folderRefPath = _folderRef.path;
    // widget.folderModel.globalRef.reference().child(widget.folderModel.folderId)
    userModelVar = Provider.of<UserModel>(context, listen: false);
    super.initState();
    // _renameFileController.text = widget.fileName;
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _renameFileController.selection = TextSelection(
            baseOffset: 0, extentOffset: _renameFileController.text.length);
      }
    });
  }

  _launchURL(String fileurl) async {
    String url = fileurl;
    print("url going to launch is $url");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  filedownloadPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Download File?"),
            content: Text('Are you sure you want to download this file?'),
            actions: [
              FlatButton(
                  color: Colors.white,
                  onPressed: () async {
                    try {
                      DatabaseService(
                              userID: widget.documentSenderId ??
                                  widget.fileModel.userId)
                          .downloadFile(
                              fileName: widget.fileModel.fileName,
                              fileDownloadLink:
                                  widget.fileModel.fileDownloadLink);
                    } catch (e) {
                      final snackBar = SnackBar(
                        content: Text('Download failed due to : {$e} error '),
                        duration: Duration(seconds: 120),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Color(0xFF02DEED)),
                  )),
              FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  deletefilePopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Delete File?"),
            content: Text('Are you sure you want to delete this file?'),
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
                      userID:
                          widget.documentSenderId ?? widget.fileModel.userId,
                      // driveRef: widget.fileModel.globalRef
                    )
                        .deleteFile(
                          fileId: widget.fileModel.fileId,
                          fileName: widget.fileModel.fileName,
                          driveRef: _folderRef,
                          // widget.fileModel.globalRef,
                        )
                        .then((value) => Navigator.pop(context));
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        });
  }

  renameFilePopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Rename file",
          ),
          content: Form(
            key: _renameFileKey,
            child: TextFormField(
                cursorColor: Color(0xFF02DEED),
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter new file name',
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
                controller: _renameFileController,
                validator: (String content) {
                  if (content.length != 0) {
                    if (content.contains("#") ||
                        content.contains("[") ||
                        content.contains("]") ||
                        content.contains("*") ||
                        content.contains("/") ||
                        content.contains("?")) {
                      return "enter valid file name";
                      // "Folder name should not contains invalid characters like #,[,],*,?";
                    } else
                      return null;
                  } else
                    return "Enter a new file name";
                }),
          ),
          actions: [
            FlatButton(
                color: Colors.white,
                onPressed: () {
                  _renameFileController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                )),
            FlatButton(
              color: Colors.white,
              onPressed: () async {
                if (_renameFileKey.currentState.validate()) {
                  DatabaseService(
                    userID: widget.documentSenderId ?? widget.fileModel.userId,
                    driveRef: _folderRef,
                    // widget.fileModel.globalRef
                  ).renameFile(
                    newFileName: _renameFileController.text,
                    fileId: widget.fileModel.fileId,
                    driveRef: _folderRef,
                    // widget.fileModel.globalRef,
                  );
                  Navigator.pop(context);
                  _renameFileController.clear();
                }
              },
              child: Text("Rename", style: TextStyle(color: Color(0xFF02DEED))),
            ),
          ],
        );
      },
    );
  }

  externalShare(BuildContext context, FileModel fileModel) {
    final String text = fileModel.fileName.toString();
    final String subject = fileModel.fileDownloadLink.toString();
    final RenderBox box = context.findRenderObject();
    Share.share(text,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void fileOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 280,
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
                    leading: Icon(
                      Icons.cloud_download,
                      color: Colors.black,
                    ),
                    title: Text("Download File"),
                    onTap: () async {
                      Navigator.pop(context);
                      filedownloadPopUp(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    title: Text("Delete File"),
                    onTap: () async {
                      Navigator.pop(context);
                      deletefilePopUp(context);
                      // delete file
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.label,
                      color: Colors.black,
                    ),
                    title: Text("Rename File"),
                    onTap: () {
                      Navigator.pop(context);
                      renameFilePopUp(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.share, color: Colors.black),
                    title: Text("Share"),
                    onTap: () async {
                      shareWithPopUp(
                        context,
                        documentSenderId: widget.documentSenderId,
                        documentType: documentType.file,
                        fileModel: widget.fileModel,
                        focusNode: _focusNode,
                      );
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.send, color: Colors.black),
                    title: Text("External Share"),
                    onTap: () {
                      Share.share(widget.fileModel.fileDownloadLink.toString(),
                          subject: widget.fileModel.fileName.toString());
                      Navigator.pop(context);
                      // externalShare(context, widget.fileModel);
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
                icon: FaIcon(
                  FontAwesomeIcons.solidFileAlt,
                  size: 60,
                  color: cardColor,
                ),
                onPressed: () async {
                  await _launchURL(widget.fileModel.fileDownloadLink);
                },
              ),
              // SizedBox(
              //   height: 2,
              // ),

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
                          "${widget.fileModel.fileName}",
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
                            fileOptions(context);
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
