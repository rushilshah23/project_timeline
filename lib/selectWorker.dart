import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchWorker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("xyz"),
      ),
      body: SearchWorkerPage(),
    );
  }
}

class SearchWorkerPage extends StatefulWidget {
  @override
  _SearchWorkerPageState createState() => _SearchWorkerPageState();
}

class _SearchWorkerPageState extends State<SearchWorkerPage> {
  String selectedValue;
  List<int> selectedItems = [];
  final List<DropdownMenuItem> items = [];
  final CollectionReference workers = Firestore.instance.collection("workers");

  Future<void> getData() async {
    await workers.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        setState(() {
          items.add(
            DropdownMenuItem(
              child: Text(result['name']),
              value: result['name'],
            ),
          );
        });
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length > 0)
      return Center(
        child: SearchableDropdown.multiple(
          items: items,
          selectedItems: selectedItems,
          hint: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Select any"),
          ),
          searchHint: "Select any",
          onChanged: (value) {
            setState(() {
              selectedItems = value;
            });
            print(selectedItems);
          },
          closeButton: (selectedItems) {
            return (selectedItems.isNotEmpty
                ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                : "Save without selection");
          },
          isExpanded: true,
        ),
      );
    else
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}
