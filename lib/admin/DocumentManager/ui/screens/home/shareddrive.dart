import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/filemodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/foldermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/receivedusermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/usermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/viewmodels/file.dart';
import 'package:project_timeline/admin/DocumentManager/core/viewmodels/folders.dart';
import 'package:project_timeline/admin/DocumentManager/ui/shared/constants.dart';
import 'package:project_timeline/admin/DocumentManager/ui/widgets/drawer.dart';
import 'package:project_timeline/admin/DocumentManager/ui/widgets/loading.dart';
import 'package:provider/provider.dart';

class ShareDrivePage extends StatefulWidget {
  final ReceivedUserModel receivedUserModel;

  ShareDrivePage({
    @required this.receivedUserModel,
  });

  @override
  _ShareDrivePageState createState() => _ShareDrivePageState();
}

class _ShareDrivePageState extends State<ShareDrivePage> {
  List<FolderCard> foldersCard = [];
  List<FileCard> filesCard = [];
  String appPath, folderappBar;
  DatabaseReference driveRef;

  List<FolderCard> folderModelList = [];
  List<FileCard> fileModelList = [];

  final FirebaseDatabase _db = FirebaseDatabase.instance;
  DatabaseReference _databaseReference;
  UserModel userModelVar;

  void initState() {
    _databaseReference = _db.reference();

    userModelVar = Provider.of<UserModel>(context, listen: false);

    super.initState();
  }

  // Future<List<FolderCard>> getFolderCardList({UserModel userModelVar}) async {
  Future<List<FolderCard>> getFolderCardList() async {
    await _databaseReference
        .reference()
        .child('shared')
        .child('users')
        .child(userModelVar.uid)
        .child('received')
        .child(widget.receivedUserModel.receivedUserUid)
        .reference()
        .once()
        .then((DataSnapshot snapshot) async {
      folderModelList.clear();

      if (snapshot.value != null) {
        try {
          var keys = snapshot.value.keys;
          var data = snapshot.value;

          folderModelList.clear();
          for (var key in keys) {
            if (data[key]['documentType'] == 'documentType.folder') {
              setState(() {
                FolderModel folderModel = new FolderModel(
                    userId: data[key]['folderSenderId'],
                    parentId: data[key]['folderParentId'],
                    folderId: data[key]['folderId'],
                    documentType: data[key]['folderDocumentType'],
                    globalRef: data[key]['folderGlobalRef'],
                    folderName: data[key]['folderName'],
                    createdAt: data[key]['folderCreatedAt']);
                folderModelList.add(FolderCard(
                  folderModel: folderModel,
                  documentSenderId: data[key]['documentSenderId'],
                ));
              });
            }
            // }
          }
        } catch (e) {
          e.toString();
        }
      }
    });

    return folderModelList;
  }

  // Future<List<FileCard>> getFileCardList({UserModel userModelVar}) async {
  Future<List<FileCard>> getFileCardList() async {
    await _databaseReference
        .reference()
        .child('shared')
        .child('users')
        .child(userModelVar.uid)
        .child('received')
        .child(widget.receivedUserModel.receivedUserUid)
        .reference()
        .once()
        .then((DataSnapshot snapshot) async {
      fileModelList.clear();
      if (snapshot.value != null) {
        try {
          var keys = snapshot.value.keys;
          var data = snapshot.value;

          fileModelList.clear();
          for (var key in keys) {
            // if (data[key]['documentSenderId'] == key) {
            if (data[key]['documentType'] == 'documentType.file') {
              setState(() {
                FileModel fileModel = new FileModel(
                    userId: data[key]['fileSenderId'],
                    parentId: data[key]['fileParentId'],
                    fileId: data[key]['fileId'],
                    documentType: data[key]['fileDocumentType'],
                    globalRef: data[key]['fileGlobalRef'],
                    fileName: data[key]['fileName'],
                    createdAt: data[key]['fileCreatedAt'],
                    fileDownloadLink: data[key]['fileDownloadLink']);
                fileModelList.add(FileCard(fileModel: fileModel));
              });
            }
          }
          // }
        } catch (e) {
          e.toString();
        }
      }
    });

    return fileModelList;
  }

  @override
  Widget build(BuildContext context) {
    var userModelVar = Provider.of<UserModel>(context);
    print(widget.receivedUserModel.receivedUserUid);

    return StreamBuilder<Event>(
        // stream: driveRef.reference().onValue,
        stream: _db
            //  _databaseReference
            .reference()
            .child('shared')
            .child('users')
            .child(userModelVar.uid)
            .child('received')
            .child(widget.receivedUserModel.userId)
            .child('documentManager')
            .reference()
            .onValue,
        builder: (context, snapshot) {
          getFileCardList();
          getFolderCardList();
          // getFileCardList(userModelVar: userModelVar);
          // getFolderCardList(userModelVar: userModelVar);
          return snapshot.hasData && !snapshot.hasError
              ? Scaffold(

                appBar: ThemeAppbar(widget.receivedUserModel.receivedUserEmailId, context),
                  // appBar: AppBar(
                  //     backgroundColor: appbarColor,
                  //     title: AutoSizeText(
                      
                  //       widget.receivedUserModel.receivedUserEmailId,
                  //       overflow: TextOverflow.visible,
                        
                  //     ),
                  //     centerTitle: true,
                     
                  //     ),
                  //drawer: homeDrawer(context),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  body: folderModelList.length != 0 || fileModelList.length != 0
                      ? ListView(children: [
                          folderModelList.length != 0 ||
                                  fileModelList.length != 0
                              ? GridView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: (folderModelList.length +
                                          fileModelList.length) ??
                                      0,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemBuilder: (_, index) {
                                    return index <
                                            folderModelList
                                                .length // &&  index >= 0
                                        ? folderModelList[index]
                                        : fileModelList[
                                            index - folderModelList.length];
                                  })
                              : Center(
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(50, 300, 50, 200),
                                    child: Text(
                                      'No Items',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: appColor),
                                    ),
                                  ),
                                )
                        ])
                      : Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(50, 300, 50, 200),
                            child: Text(
                              'No Items',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: appColor),
                            ),
                          ),
                        ),
                )
              : Loading();
        });
  }
}
