import 'package:Aol_docProvider/core/models/filemodel.dart';
import 'package:Aol_docProvider/core/models/foldermodel.dart';

class ReceivedModel {
  final FolderModel folderModel;
  final FileModel fileModel;

  ReceivedModel({
    this.fileModel,
    this.folderModel,
  });
}
