import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:project_timeline/UserSide/AboutUs/MainPage/HomeScreen.dart';
import 'package:project_timeline/UserSide/Feedback/TextPages/IAHVText.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutIAHV extends StatefulWidget {
  final String title;
  // aboutIAHV({Key key, this.title}) : super(key: key);
  AboutIAHV({this.title});

  @override
  _AboutIAHVState createState() => _AboutIAHVState();
}

class _AboutIAHVState extends State<AboutIAHV> {
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
        title: IAHVText[1],
        maxLineTitle: 5,
        styleTitle: TextStyle(
            fontFamily: 'DancingScript',
            color: Colors.white70,
            fontSize: 25.0,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic),
        centerWidget: Container(
            width: 250.0,
            height: 150.0,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/IAHVLogo.jpg')))),
        widgetDescription: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              IAHVText[2],
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic),
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
    slides.add(
      new Slide(
          backgroundImage: 'assets/waterimg.jpg',
          title: IAHVText[3],
          maxLineTitle: 5,
          styleTitle: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: 'DancingScript'),
          centerWidget: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite_border,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            IAHVText[4],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  SizedBox(height: 15),
                  Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Container(
                      height: 60,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.language,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              IAHVText[5],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 15),
                  Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Container(
                      height: 60,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              IAHVText[6],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 15),
                  Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Container(
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.people,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              IAHVText[7],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
//        colorBegin: Color(0xffe2f3fb),
//        colorEnd: Color(0xff005c9d),
//        directionColorBegin: Alignment.topCenter,
//        directionColorEnd: Alignment.bottomCenter,
          backgroundOpacity: 0.7),
    );
    slides.add(
      new Slide(
          title: IAHVText[8],
          maxLineTitle: 5,
          styleTitle: TextStyle(
              fontFamily: 'DancingScript',
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          widgetDescription: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      IAHVText[9],
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      IAHVText[10],
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundImage: 'assets/waterimg.jpg',
          backgroundOpacity: 0.7),
    );
  }
  void onDonePress() {
    // Do what you want
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) =>  HomeScreen()),
    );
  }
  // loadTextFields() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   language = sharedPreferences.getString('language');
  //   if (language != 'en') {
  //     for (var i = 0; i < IAHVText.length; i++) {
  //       await Language(language).getTranslation(IAHVText[i]).then((value) {
  //         setState(() {
  //           IAHVText[i] = value;
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
      appBar: AppBar(
        title: Text(
          'About IAHV',
          style: TextStyle(color: darkestColor),
        ),
        centerTitle: true,
        backgroundColor: appbarColor,
      ),
      body: IntroSlider(
        isShowSkipBtn: false,
        isShowPrevBtn: true,
        slides: this.slides,
        isShowDoneBtn: true,
        onDonePress: this.onDonePress,
        colorActiveDot: Colors.white,
        colorDot: Colors.white30,
        isScrollable: true,
        renderNextBtn: Icon(Icons.arrow_forward_ios, color: Colors.white),
        renderPrevBtn: Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
    );
  }
}
