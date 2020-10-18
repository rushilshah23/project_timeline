import 'package:flutter/material.dart';

class FolderModel {
  final dynamic userId;
  final dynamic parentId;
  final dynamic folderId;
  final dynamic documentType;
  final dynamic globalRef;
  final dynamic folderName;
  final dynamic createdAt;

  FolderModel(
      {@required this.userId,
      @required this.parentId,
      @required this.folderId,
      @required this.documentType,
      @required this.globalRef,
      @required this.folderName,
      @required this.createdAt});
}
