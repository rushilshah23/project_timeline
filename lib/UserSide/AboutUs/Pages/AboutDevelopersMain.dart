import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:link/link.dart';
import 'package:project_timeline/UserSide/AboutUs/Pages/AboutDevelopers.dart';
import 'package:project_timeline/UserSide/Feedback/TextPages/DevelopersText.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDevelopersPage extends StatefulWidget {
  final String title;
  // aboutIAHV({Key key, this.title}) : super(key: key);
  MainDevelopersPage({this.title});

  @override
  _MainDevelopersPageState createState() => _MainDevelopersPageState();
}

class _MainDevelopersPageState extends State<MainDevelopersPage> {
  SharedPreferences sharedPreferences;
  String language;
  List<Slide> slides = new List();
  // Language _languageHome;
  void initState() {
    print("in homepage");
    // _languageHome = context.read<Language>();
    super.initState();
    slides.add(
      new Slide(
        centerWidget: Container(
            width: 250.0,
            height: 200.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/sakeclogo.jpg')))),
        widgetDescription: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                Text(
                  DevelopersText[1],
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 25),
                Link(
                  child: Text(
                    DevelopersText[2],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: commonBGColor,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic),
                  ),
                  url: 'https://www.shahandanchor.com/home/',
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DevelopersPage()));
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

  // loadTextFields() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   language = sharedPreferences.getString('language');
  //   if (language != 'en') {
  //     for (var i = 0; i <DevelopersText.length; i++) {
  //       await Language(language).getTranslation(DevelopersDevelopersText[i]).then((value) {
  //         setState(() {
  //          DevelopersText[i] = value;
  //         });
  //       });
  //     }
  //   }
  //   // return text1 =
  //   //     (await _langVar.getTranslation('We serve the society')).toString();
  // }

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
