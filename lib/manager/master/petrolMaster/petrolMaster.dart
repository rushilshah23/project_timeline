import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/manager/master/petrolMaster/AddPetrolLocation.dart';

class PetrolMaster extends StatefulWidget {
  @override
  _PetrolMasterState createState() => _PetrolMasterState();
}

class _PetrolMasterState extends State<PetrolMaster> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Map petrolPumpData;
  List allPetrolPump = List();

  @override
  void initState() {
    super.initState();
    getPetrolPumpDetails();
  }

  getPetrolPumpDetails() async {
    databaseReference.child("masters").once().then((DataSnapshot snapshot) {
      Map petrolPumpLocations = snapshot.value["petrolMaster"];
      setState(() {
        petrolPumpData = petrolPumpLocations;
      });
      debugPrint(petrolPumpData.toString());
    });
  }

  Widget petrolMaster(int index) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text(allPetrolPump[index]["petrolPumpName"].toString()),
            subtitle:
                Text(allPetrolPump[index]["petrolPumpAddress"].toString()),
            onTap: () {
              debugPrint('This is to test ListTile');
                  return  showDialog(
                  context: context,
                  builder: (_) => AddPetrolLocation(),
                );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Petrol Locations'),
      ),
      body: StreamBuilder(
          stream:
              databaseReference.child("masters").child("petrolMaster").onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              allPetrolPump = [];
              data.forEach(
                (index, data) => allPetrolPump.add({"key": index, ...data}),
              );

              return new Column(
                children: <Widget>[
                  new Expanded(
                    child: new ListView.builder(
                      itemCount: allPetrolPump.length,
                      itemBuilder: (context, index) {
                        return petrolMaster(index);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddPetrolLocation(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
