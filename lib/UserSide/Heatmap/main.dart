import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position position;
  Widget _child;
  // List<String> _progress = ['Not Started', 'Ongoing', 'Completed'];
  List projectValues = [];

  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    getCurrentLocation();
    populateClients();
    super.initState();
  }

  void getCurrentLocation() async {
    //Position res = await Geolocator().getCurrentPosition();
    setState(() {
      //position = res;
      _child = mapWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Heatmap'),
      ),
      body: _child,
    );
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers.values),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 6.5,
        bearing: 15.0,
        tilt: 75.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }

  populateClients() {
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(request, requestId) {
    databaseReference.child("projects").once().then((DataSnapshot snapshot) {
      Map projectMap = snapshot.value;
      // debugPrint(projectMap.toString());
      setState(() {
        projectValues = projectMap.values.toList();
        // debugPrint(projectValues.toString());
      });

      var markerIdVal = requestId;
      final MarkerId markerId = MarkerId(markerIdVal);

      for (int i = 0; i < projectValues.length; i++) {
        debugPrint(projectValues[i]['projectStatus']);

        Marker marker = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(
              request['location'].latitude, request['location'].longitude),
          infoWindow: InfoWindow(
            title: request['place'],
            snippet: "STATUS: " + projectValues[i]['projectStatus'],
          ),
        );

        setState(() {
          markers[markerId] = marker;
        });
      }
    });
  }
}
