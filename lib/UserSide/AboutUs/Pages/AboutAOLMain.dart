import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:project_timeline/UserSide/AboutUs/Pages/AOLPage.dart';
import 'package:project_timeline/UserSide/Feedback/TextPages/AOLText.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';

class MainAOLPage extends StatefulWidget {
  final String title;
  // MainAOLPage({Key key, this.title}) : super(key: key);
  MainAOLPage({this.title});

  @override
  _MainAOLPageState createState() => _MainAOLPageState();
}

class _MainAOLPageState extends State<MainAOLPage> {
  List<Slide> slides = new List();
  // Language _languageHome;
  void initState() {
    print("in homepage");
    // _languageHome = context.read<Language>();
    super.initState();
    slides.add(
      new Slide(
        title: AOLText[1],
        maxLineTitle: 2,
        styleTitle: TextStyle(
            color: Colors.white70,
            fontSize: 25.0,
            fontFamily: 'DancingScript',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic),
        centerWidget: Container(
            width: 250.0,
            height: 170.0,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('assets/logo.jpg')))),
        widgetDescription: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AOLText[2],
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AOLPage()));
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
        backgroundOpacity: 0.7,
        backgroundImage: 'assets/waterimg.jpg',
//        directionColorBegin: Alignment.topLeft,
//        directionColorEnd: Alignment.bottomRight,
//        onCenterItemPress: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        isShowSkipBtn: false,
        isShowPrevBtn: false,
        isShowDoneBtn: false,
        isShowDotIndicator: false,
        isShowNextBtn: false,
        slides: this.slides,
        isScrollable: false,
        // colorActiveDot: Colors.white,
        // colorDot: Colors.white30,
        // renderNextBtn: Icon(Icons.arrow_forward_ios, color: Colors.white),
        // renderPrevBtn: Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
    );
  }
}
