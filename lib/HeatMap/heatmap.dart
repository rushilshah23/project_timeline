import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

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
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      _child = mapWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heat Map'),
        backgroundColor: Color(0xff02b9f3),
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
    FirebaseFirestore.instance.collection('markers').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          initMarker(docs.docs[i].data, docs.docs[i].id);
        }
      }
    });
  }

  void initMarker(request, requestId) async{

    Map projectMap;
    projectValues.clear();
    //projectValues
   await  databaseReference.child("projects").once().then((DataSnapshot snapshot) {
       
     // debugPrint(projectMap.toString());
          projectMap=snapshot.value;
      
  });

  debugPrint("-----------------------------"+projectMap[request['projectID']]["projectStatus"].toString());

 var markerIdVal = requestId;                                          
      final MarkerId markerId = MarkerId(markerIdVal);
   
      Marker marker = Marker(   
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),       
      position:
          LatLng(request['location'].latitude, request['location'].longitude),
      infoWindow:
          InfoWindow(title: request['place'],
          snippet: "STATUS: "+projectMap[request['projectID']]["projectStatus"].toString(),
          ),
    );
  
    setState(() {
      markers[markerId] = marker;
      
    });


  }
}