import 'package:project_timeline/admin/DocumentManager/core/models/filemodel.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/foldermodel.dart';

class ReceivedModel {
  final FolderModel folderModel;
  final FileModel fileModel;

  ReceivedModel({
    this.fileModel,
    this.folderModel,
  });
}
