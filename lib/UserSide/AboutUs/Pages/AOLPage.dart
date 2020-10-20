import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:project_timeline/UserSide/Feedback/MainFeedbackPage/feedback.dart';
import 'package:project_timeline/UserSide/Feedback/TextPages/AOLText.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';

class AOLPage extends StatefulWidget {
  final String title;
  // AOLPage({Key key, this.title}) : super(key: key);
  AOLPage({this.title});

  @override
  _AOLPageState createState() => _AOLPageState();
}

class _AOLPageState extends State<AOLPage> {
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
                    fit: BoxFit.fill, image: AssetImage('assets/logo.jpg')))),
        widgetDescription: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              AOLText[2],
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
          title: AOLText[3],
          maxLineTitle: 4,
          styleTitle: TextStyle(
              fontFamily: 'DancingScript',
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
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
                            AOLText[4],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
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
                              AOLText[5],
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
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
                              AOLText[6],
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
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
                              AOLText[7],
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
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
          title: AOLText[8],
          centerWidget: Container(
              width: 190.0,
              height: 190.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/photo.jpg')))),
          widgetDescription: Center(
              child: Column(
            children: [
              Text(
                AOLText[9],
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Color(0xffe2f3fb),
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Center(
                  child: Text(
                    AOLText[10],
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Center(
                  child: Text(
                    AOLText[11],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
          )),
          backgroundImage: 'assets/waterimg.jpg',
          backgroundOpacity: 0.7),
    );
    slides.add(
      new Slide(
          title: AOLText[12],
          centerWidget: Text(
            AOLText[13],
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontStyle: FontStyle.italic, color: Colors.white, fontSize: 20),
          ),
          widgetDescription: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AOLText[14],
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AOLText[15],
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AOLText[16],
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AOLText[17],
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocalFeedback()));
                    },
                    icon: Icon(Icons.feedback),
                    label: Text(
                      AOLText[18],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          backgroundImage: 'assets/waterimg.jpg',
          backgroundOpacity: 0.7),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About AOL', style: TextStyle(color: darkestColor)),
        centerTitle: true,
        backgroundColor: appbarColor,
      ),
      body: IntroSlider(
        isShowSkipBtn: false,
        isShowPrevBtn: true,
        slides: this.slides,
        colorActiveDot: Colors.white,
        colorDot: Colors.white30,
        isScrollable: true,
        renderNextBtn: Icon(Icons.arrow_forward_ios, color: Colors.white),
        renderPrevBtn: Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
    );
  }
}
