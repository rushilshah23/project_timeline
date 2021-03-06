import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/AboutUs/Pages/AOLPage.dart';

import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:project_timeline/languages/setLanguageText.dart';

class MainAOLPage extends StatefulWidget {
  final String title;
  // MainAOLPage({Key key, this.title}) : super(key: key);
  MainAOLPage({this.title});

  @override
  _MainAOLPageState createState() => _MainAOLPageState();
}

class _MainAOLPageState extends State<MainAOLPage> {
  void initState() {
    print("in homepage");
    // _languageHome = context.read<Language>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/waterimg.jpg'),
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.darken),
                fit: BoxFit.fitHeight,
              ),
            ),
            padding: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      aolTranslationText[1],
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 25.0,
                        fontFamily: 'DancingScript',
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: 250.0,
                        height: 170.0,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/logo.jpg')))),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            aolTranslationText[2],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AOLPage()));
                                },
                                child: Text('Read More...',
                                    style: TextStyle(
                                        color: readMoreColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
