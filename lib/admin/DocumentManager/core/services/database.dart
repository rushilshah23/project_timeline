import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import "package:firebase_database/firebase_database.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/filemodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/foldermodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/pathnavigator.dart';
import 'package:project_timeline/admin/DocumentManager/ui/shared/constants.dart';

class DatabaseService {
  final String userID;
  final DatabaseReference driveRef;

  DatabaseService({
    this.userID,
    this.driveRef,
  });

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  StorageReference _dbStorage = FirebaseStorage.instance.ref();

  List<FileModel> filesCard = [];
  List<FolderModel> foldersCard = [];

  Future updateUserData({String folderName}) async {
    bool present = false;
    await globalRef
        .reference()
        .child('users')
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        var keys = snapshot.value.keys;
        var data = snapshot.value;
        for (var key in keys) {
          print("searcching key is " + key);
          if (key == userID) {
            present = true;
            return null;
          }
          //   else {
          //     await globalRef
          //         .reference()
          //         .child('users')
          //         .child(userID)
          //         .child('documentManager')
          //         .set({
          //       'folderName': folderName,
          //       'userId': userID,
          //     });
          //   }
        }
        if (present == false) {
          await globalRef
              .reference()
              .child('users')
              .child(userID)
              .child('documentManager')
              .set({
            'folderName': folderName,
            'userId': userID,
          });
        }
      } else {
        if (present == false) {
          await globalRef
              .reference()
              .child('users')
              .child(userID)
              .child('documentManager')
              .set({
            'folderName': folderName,
            'userId': userID,
          });
        }
      }
    });
  }

  Future createFolder({
    String parentId,
    String folderName,
    documentType documentType,
    DatabaseReference driveRef,
  }) async {
    var newKey = driveRef.reference().push().key;
    print(newKey);

    await driveRef.child('inFolders').child(newKey).set({
      'userId': userID,
      'parentId': parentId,
      'folderId': newKey,
      'documentType': documentType.toString(),
      'folderName': folderName,
      'createdAt': Timestamp.now().toDate().toIso8601String(),
      'globalRef': driveRef.reference().path,
    });
  }

  Future chooseFile(
      {String parentId,
      documentType documentType,
      DatabaseReference driveRef}) async {
    File file = await FilePicker.getFile(type: FileType.custom);

    String fileName = file.path.split('/').last;

    var newKey = driveRef.reference().push().key;

    StorageUploadTask uploadTask = _dbStorage
        .child(driveRef.child('inFolders').reference().path)
        .child(newKey)
        .putFile(file);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    await driveRef.child('inFolders').child(newKey).set({
      'userId': userID,
      'parentId': parentId,
      'fileId': newKey,
      'fileName': fileName,
      'documentType': (documentType.toString()),
      'fileDownloadLink': url,
      'createdAt': Timestamp.now().toDate().toIso8601String(),
      'globalRef': driveRef.reference().path,
    });
  }

  Future renameFolder({
    String newFolderName,
    String folderId,
    DatabaseReference driveRef,
  }) async {
    await driveRef.child(folderId).reference().update({
      'folderName': newFolderName,
      'modifiedAt': Timestamp.now().toDate().toIso8601String(),
    });

    String receiverId;
    FirebaseDatabase _fbdb = FirebaseDatabase.instance;
    DatabaseReference _db = _fbdb.reference();
    await _db
        .reference()
        .child('shared')
        .child('users')
        .child(userID)
        .child('send')
        .reference()
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        var keys = snapshot.value.keys;
        for (var key in keys) {
          await _db
              .reference()
              .child('shared')
              .child('users')
              .child(userID)
              .child('send')
              .child(key)
              .reference()
              .once()
              .then((DataSnapshot snapshot) async {
            if (snapshot.value != null) {
              var keys = snapshot.value.keys;
              for (var key2 in keys) {
                if (key2 == folderId) {
                  receiverId = key;
                  print(receiverId);
                  await _db
                      .reference()
                      .child('shared')
                      .child('users')
                      .child(receiverId)
                      .child('received')
                      .child(userID)
                      // .child(key)
                      .reference()
                      .child(key2)
                      .update({
                    'folderName': newFolderName,
                    'modifiedAt': Timestamp.now().toDate().toIso8601String(),
                  }).then((_) async {
                    await _db
                        .reference()
                        .child('shared')
                        .child('users')
                        .child(userID)
                        .child('send')
                        .child(receiverId)
                        .child(folderId)
                        .update({
                      'folderName': newFolderName,
                      'modifiedAt': Timestamp.now().toDate().toIso8601String(),
                    });
                  });
                }
              }
            }
          });
        }
      }
    });
  }

  Future deleteFolder({
    String folderId,
    DatabaseReference driveRef,
  }) async {
    // deleteFolderFromdbStorage(driveRef: driveRef, folderId: folderId);

    try {
      print("before folder deleted ${driveRef.path}/$folderId");
      await driveRef.child(folderId).reference().remove();
      print("after folder deleted ${driveRef.path}/$folderId");
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      await _dbStorage
          .child(driveRef.reference().path)
          .child(folderId)
          .delete();
    } catch (e) {
      print(e.toString());
    }

    // _dbStorage.child(driveRef.reference().path).child(folderId).delete();

    // await globalRef.reference().child(folderId).remove();

    // String ifexist =
    //     // _dbStorage.child(globalRef.toString()).child(folderId).path;
    //     globalRef.reference().child(folderId).path;

    // print("ifexists path = $ifexist");
    // if (ifexist != null) {
    //   await _dbStorage.child(globalRef.toString()).child(folderId).delete();
    // }

    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(driveRef.reference().path);
    // var deleteTask = storageReference.child(folderId).delete();

    // TODO solve in a update

    // var deleteRef = driveRef.reference().child(folderId).reference();

    // while (deleteRef.reference() != null) {
    //   await deleteRef.once().then((DataSnapshot snapshot) async {
    //     try {
    //       var keys = snapshot.value.key;
    //       var data = snapshot.value;

    //       for (var key in keys) {
    //         while (data[key]['documentType'] != 'documentType.file') {
    //           deleteRef = deleteRef.child(data[key]['folderId']).reference();

    //           deleteFolder(
    //             driveRef: deleteRef,
    //           );
    //         }
    //         await _dbStorage
    //             .child(deleteRef.reference().path)
    //             .child(data[key]['fileId'])
    //             .child(data[key]['fileName'])
    //             .delete();
    //       }
    //       await deleteRef.reference().child(folderId).remove();
    //     } catch (e) {
    //       print(e.toString());
    //     }
    //   });
    // }

    // AT SHARED SECTION
    String receiverId;
    FirebaseDatabase _fbdb = FirebaseDatabase.instance;
    DatabaseReference _db = _fbdb.reference();
    print("at send end $userID");
    try {
      await _db
          .reference()
          .child('shared')
          .child('users')
          .child(userID)
          .child('send')
          .reference()
          .once()
          .then((DataSnapshot snapshot) async {
        if (snapshot.value != null) {
          var keys = snapshot.value.keys;
          for (var key in keys) {
            await _db
                .reference()
                .child('shared')
                .child('users')
                .child(userID)
                .child('send')
                .child(key)
                .reference()
                .once()
                .then((DataSnapshot snapshot) async {
              if (snapshot.value != null) {
                var keys = snapshot.value.keys;
                for (var key2 in keys) {
                  if (key2 == folderId) {
                    receiverId = key;
                    print(receiverId);
                    await _db
                        .reference()
                        .child('shared')
                        .child('users')
                        .child(receiverId)
                        .child('received')
                        .child(userID)
                        // .child(key)
                        .reference()
                        .child(key2)
                        .remove()
                        .then((_) async {
                      await _db
                          .reference()
                          .child('shared')
                          .child('users')
                          .child(userID)
                          .child('send')
                          .child(receiverId)
                          .child(folderId)
                          .remove();
                    });
                  }
                }
              }
            });
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  deleteFolderFromdbStorage(
      {DatabaseReference driveRef, String folderId}) async {
    await driveRef.child(folderId).once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        var data = snapshot.value;
        var keys = snapshot.value.keys;
        for (var key in keys) {
          if (data['inFolders'] != null) {
            print("inFOlders " + data['inFolders']);
          }
        }
      }
    });
    // await _dbStorage.child(driveRef.reference().path).child(folderId).delete();
  }

  Future renameFile(
      {String newFileName, String fileId, DatabaseReference driveRef}) async {
    // await driveRef.reference().child(fileId).update({
    await driveRef.reference().child(fileId).update({
      'fileName': newFileName,
      'modifiedAt': Timestamp.now().toDate().toIso8601String(),
    });

    String receiverId;
    FirebaseDatabase _fbdb = FirebaseDatabase.instance;
    DatabaseReference _db = _fbdb.reference();
    await _db
        .reference()
        .child('shared')
        .child('users')
        .child(userID)
        .child('send')
        .reference()
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        var keys = snapshot.value.keys;
        for (var key in keys) {
          await _db
              .reference()
              .child('shared')
              .child('users')
              .child(userID)
              .child('send')
              .child(key)
              .reference()
              .once()
              .then((DataSnapshot snapshot) async {
            if (snapshot.value != null) {
              var keys = snapshot.value.keys;
              for (var key2 in keys) {
                if (key2 == fileId) {
                  receiverId = key;
                  print(receiverId);
                  await _db
                      .reference()
                      .child('shared')
                      .child('users')
                      .child(receiverId)
                      .child('received')
                      .child(userID)
                      // .child(key)
                      .reference()
                      .child(key2)
                      .update({
                    'fileName': newFileName,
                    'modifiedAt': Timestamp.now().toDate().toIso8601String(),
                  }).then((_) async {
                    await _db
                        .reference()
                        .child('shared')
                        .child('users')
                        .child(userID)
                        .child('send')
                        .child(receiverId)
                        .child(fileId)
                        .update({
                      'fileName': newFileName,
                      'modifiedAt': Timestamp.now().toDate().toIso8601String(),
                    });
                  });
                }
              }
            }
          });
        }
      }
    });
  }

  Future deleteFile(
      {String fileName, String fileId, DatabaseReference driveRef}) async {
    await driveRef.reference().child(fileId).remove();
    print("delete path ${driveRef.path}");

    await _dbStorage.child(driveRef.reference().path).child(fileId).delete();

    // AT SHARED SECTION
    String receiverId;
    FirebaseDatabase _fbdb = FirebaseDatabase.instance;
    DatabaseReference _db = _fbdb.reference();
    await _db
        .reference()
        .child('shared')
        .child('users')
        .child(userID)
        .child('send')
        .reference()
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        var keys = snapshot.value.keys;
        for (var key in keys) {
          await _db
              .reference()
              .child('shared')
              .child('users')
              .child(userID)
              .child('send')
              .child(key)
              .reference()
              .once()
              .then((DataSnapshot snapshot) async {
            if (snapshot.value != null) {
              var keys = snapshot.value.keys;
              for (var key2 in keys) {
                if (key2 == fileId) {
                  receiverId = key;
                  print(receiverId);
                  await _db
                      .reference()
                      .child('shared')
                      .child('users')
                      .child(receiverId)
                      .child('received')
                      .child(userID)
                      // .child(key)
                      .reference()
                      .child(key2)
                      .remove()
                      .then((_) async {
                    await _db
                        .reference()
                        .child('shared')
                        .child('users')
                        .child(userID)
                        .child('send')
                        .child(receiverId)
                        .child(fileId)
                        .remove();
                  });
                }
              }
            }
          });
        }
      }
    });
  }

  Future<void> downloadFile({String fileDownloadLink, String fileName}) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final dir = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
          url: fileDownloadLink,
          savedDir: dir.path,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true);
    } else {
      print("Please grant the permission");
    }
  }

  Stream<Event> get documentStream {
    return driveRef.onValue;
  }

  Future<String> getuserIdfromEmailId({String emailId}) async {
    String receiverId;
    try {
      await _db.reference().child('users').reference().once().then((snapshot) {
        if (snapshot.value != null) {
          var data = snapshot.value;
          var keys = snapshot.value.keys;
          // if (data != null) {
          for (var key in keys) {
            if (data[key]['documentManager'] != null) {
              print(
                  "Searched email id ${data[key]['documentManager']['folderName']}");
              if (data[key]['documentManager']['folderName'] == emailId) {
                print(
                    "searching userid is ${data[key]['documentManager']['userId']}");
                receiverId = data[key]['documentManager']['userId'];
              }
            } else
              return null;
            // return Scaffold.of(context).showSnackBar(
            //     SnackBar(content: Text("Email id: $emailId doesn't exists")));
          }
        }

        // }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return receiverId ?? null;
  }

  getEmailIdfromUserId({String userId}) async {
    String receiverEmailId;
    try {
      await _db.reference().child('users').reference().once().then((snapshot) {
        if (snapshot.value != null) {
          var data = snapshot.value;
          var keys = snapshot.value.keys;
          // if (data != null) {
          for (var key in keys) {
            if (data[key]['documentManager'] != null) {
              if (data[key]['documentManager']['userId'] == userId) {
                receiverEmailId = data[key]['documentManager']['folderName'];
              }
            } else
              return null;
            // return Scaffold.of(context).showSnackBar(
            //     SnackBar(content: Text("Email id: $emailId doesn't exists")));
          }
        }

        // }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return receiverEmailId ?? null;
  }

  shareWith({
    @required List<String> receiverEmailId,
    FolderModel folderModel,
    FileModel fileModel,
    @required documentType docType,
  }) async {
    for (var i = 0; i < receiverEmailId.length; i++) {
      print("in share with");
      FirebaseDatabase _fbdb = FirebaseDatabase.instance;
      DatabaseReference _db = _fbdb.reference();
      var receiverId = await getuserIdfromEmailId(emailId: receiverEmailId[i]);

      if (receiverId != null) {
        print('before push');
        // _db
        //     .reference()
        //     .child('shared')
        //     .child('users')
        //     .child(userID)
        //     .child('send')
        //     .child(receiverId)
        //     .push()
        //     .key;
        print('after push');

        if (docType == documentType.folder) {
          await _db
              .reference()
              .child('shared')
              .child('users')
              .child(userID)
              .child('send')
              .child(receiverId)
              .child(folderModel.folderId)
              .reference()
              .set({
            'receiverEmailId': receiverEmailId[i],
            'documentSenderId': folderModel.userId ?? null,
            'documentReceiverId': receiverId ?? null,
            'folderId': folderModel.folderId ?? null,
            'folderParentId': folderModel.parentId ?? null,
            'documentType': folderModel.documentType ?? null,
            'folderGlobalRef': folderModel.globalRef.toString() ?? null,
            'folderName': folderModel.folderName ?? null,
            'folderCreatedAt': folderModel.createdAt ?? null,
          });
          print('surpassed');

          await _db
              .reference()
              .child('shared')
              .child('users')
              .child(receiverId)
              .child('received')
              .child(userID)
              .child(folderModel.folderId)
              .reference()
              .set({
            'receiverEmailId': receiverEmailId[i],
            'documentSenderId': folderModel.userId ?? null,
            'documentReceiverId': receiverId ?? null,
            'folderId': folderModel.folderId ?? null,
            'folderParentId': folderModel.parentId ?? null,
            'documentType': folderModel.documentType ?? null,
            'folderGlobalRef': folderModel.globalRef.toString() ?? null,
            'folderName': folderModel.folderName ?? null,
            'folderCreatedAt': folderModel.createdAt ?? null,
          });
        }

        if (docType == documentType.file) {
          await _db
              .reference()
              .child('shared')
              .child('users')
              .child(userID)
              .child('send')
              .child(receiverId)
              .child(fileModel.fileId)
              .reference()
              .set({
            'receiverEmailId': receiverEmailId[i],
            'fileSenderId': fileModel.userId ?? null,
            'fileParentId': fileModel.parentId ?? null,
            'fileId': fileModel.fileId ?? null,
            'fileName': fileModel.fileName ?? null,
            'fileGlobalRef': fileModel.globalRef ?? null,
            'fileDownloadLink': fileModel.fileDownloadLink ?? null,
            'fileCreatedAt': fileModel.createdAt ?? null,
            'documentType': fileModel.documentType ?? null,
            'documentSenderId': fileModel.userId ?? null,
          });

          await _db
              .reference()
              .child('shared')
              .child('users')
              .child(receiverId)
              .child('received')
              .child(userID)
              .child(fileModel.fileId)
              .reference()
              .set({
            'receiverEmailId': receiverEmailId[i],
            'fileSenderId': fileModel.userId ?? null,
            'fileParentId': fileModel.parentId ?? null,
            'fileId': fileModel.fileId ?? null,
            'fileName': fileModel.fileName ?? null,
            'fileGlobalRef': fileModel.globalRef ?? null,
            'fileDownloadLink': fileModel.fileDownloadLink ?? null,
            'fileCreatedAt': fileModel.createdAt ?? null,
            'documentType': fileModel.documentType ?? null,
            'documentSenderId': fileModel.userId ?? null,
          });
        }
      } else
        debugPrint('receievr id not found');
    }
  }
}
