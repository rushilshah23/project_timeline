import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderList extends StatefulWidget {
  @override
  _FolderListState createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
  @override
  Widget build(BuildContext context) {
    final folders = Provider.of<QuerySnapshot>(context);
    for (var doc in folders.docs) {
      print(doc.data());
    }
    return Container();
  }
}
