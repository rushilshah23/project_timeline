import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/languages/setLanguageText.dart';

void main() => runApp(new HeatMap());

class HeatMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new HeatMapPage(),
    );
  }
}

class HeatMapPage extends StatefulWidget {
  const HeatMapPage({Key key}) : super(key: key);

  @override
  State<HeatMapPage> createState() => _FirstScreen();
}

class _FirstScreen extends State<HeatMapPage> {
  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position position;
  Widget _child;
  List projectValues = [];

  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    getCurrentLocation();
    populateClients();
    super.initState();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      _child = mapWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: plainAppBar(context: context, title: homePageTranslationText[1]),
      body: _child,
    );
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.terrain,
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
    FirebaseFirestore.instance.collection('markers').get().then((val) {
      if (val.docs.isNotEmpty) {
        for (int i = 0; i < val.docs.length; ++i) {
          initMarker(val.docs[i].data(), val.docs[i].id);
        }
      }
    });
  }

  void initMarker(request, requestId) async {
    Map projectMap;
    projectValues.clear();
    //projectValues
    await databaseReference
        .child("projects")
        .once()
        .then((DataSnapshot snapshot) {
      projectMap = snapshot.value;
    });

    final MarkerId markerId = MarkerId(requestId);

    if (projectMap[request['projectID']]["projectStatus"].toString() ==
        'Not Started') {
      Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position:
            LatLng(request['location'].latitude, request['location'].longitude),
        infoWindow: InfoWindow(
          title: projectMap[request['projectID']]["projectName"].toString(),
          snippet: "Not Started",
        ),
      );

      setState(() {
        markers[markerId] = marker;
      });
    } else if (projectMap[request['projectID']]["projectStatus"].toString() ==
        'Ongoing') {
      Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position:
            LatLng(request['location'].latitude, request['location'].longitude),
        infoWindow: InfoWindow(
          title: projectMap[request['projectID']]["projectName"].toString(),
          snippet: "Progress: " +
              projectMap[request['projectID']]["progressPercent"].toString() +
              "%",
        ),
      );

      setState(() {
        markers[markerId] = marker;
      });
    } else {
      Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position:
            LatLng(request['location'].latitude, request['location'].longitude),
        infoWindow: InfoWindow(
            title: projectMap[request['projectID']]["projectName"].toString(),
            snippet: "Completed"),
      );

      setState(() {
        markers[markerId] = marker;
      });
    }
  }
}
