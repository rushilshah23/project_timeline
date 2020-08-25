import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
    databaseReference.child("projects").once().then((DataSnapshot snapshot) {
      Map petrolPumpLocations = snapshot.value["petrolLocations"];
      setState(() {
        petrolPumpData = petrolPumpLocations;
      });
      debugPrint(petrolPumpData.toString());
    });
  }

  Widget petrolMaster(index) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text('test'),
            subtitle: Text("This is nothing"),
            onTap: () {
              debugPrint('This is to test ListTile');
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
      // body: StreamBuilder(
      //   stream: databaseReference
      //       .child("projects")
      //       .child("petrolLocations")
      //       .onValue,
      //   builder: (context, snap) {
      //     if (snap.hasData &&
      //         !snap.hasError &&
      //         snap.data.snapshot.value != null) {
      //       Map data = snap.data.snaphot.value;
      //       data.forEach(
      //           (index, data) => allPetrolPump.add({"key": index, ...data}));
      //       debugPrint(allPetrolPump.toString());

      //       // return new Column(
      //       //   children: [
      //       //     new Expanded(
      //       //         child: new ListView.builder(
      //       //             itemCount: allPetrolPump.length,
      //       //             itemBuilder: (context, index) {
      //       //               return petrolMaster(index);
      //       //             })),
      //       //   ],
      //       // );
      //       return petrolMaster(2);
      //     }
      //   },
      // )
      body: petrolMaster("est"),
    );
  }
}
