class FileModel {
  final dynamic userId;
  final dynamic parentId;
  final dynamic fileId;
  final dynamic fileName;
  final dynamic globalRef;
  final dynamic documentType;
  final dynamic fileDownloadLink;
  final dynamic createdAt;

  FileModel(
      {this.userId,
      this.parentId,
      this.fileId,
      this.fileName,
      this.globalRef,
      this.documentType,
      this.fileDownloadLink,
      this.createdAt});
}
