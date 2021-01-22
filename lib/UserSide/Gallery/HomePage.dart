import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
import 'details_page.dart';

class DbTesting extends StatefulWidget {
  @override
  _DbTestingState createState() => _DbTestingState();
}

class _DbTestingState extends State<DbTesting> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  Map projectMap;
  List projectValues = [];
  List images = [];
  List temp;
  void initState() {
    super.initState();

    databaseReference.child("projects").once().then((DataSnapshot snapshot) {
      Map projectMap = snapshot.value;
      setState(() {
        projectValues = projectMap.values.toList();
      });

      debugPrint(projectValues.toString());
      for (int i = 0; i < projectValues.length; i++) {
        debugPrint("approved Images $i " +
            projectValues[i]["approvedImages"].toString());
        Map projectDetails = projectValues[i];
        if (projectDetails.containsKey("approvedImages")) {
          List tempImages = projectDetails["approvedImages"];
          for (int j = 0; j < tempImages.length; j++) {
            images.add(tempImages[j].toString());
          }
        }
      }
      debugPrint(images.toString());
    });
  }

  Widget build(BuildContext context) {
    if (projectValues.length != 0) {
      return Scaffold(
        backgroundColor: Color(0xFF018abd),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Text(
                homePageTranslationText[0],
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return RawMaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                imagePath: (images[index]),
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'logo$index',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: images.length,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}

class ImageDetails {
  final String imagePath;

  ImageDetails({
    @required this.imagePath,
  });
}
