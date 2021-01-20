import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';

import 'package:project_timeline/languages/setLanguageText.dart';

var card1text = "Gallery";
var card2text = "Heat Map";
var card3text = "Feedback";
var card4text1 = "Charity LeaderBoard";
var card4text2 = "LeaderBoard";
var aboutuscardtext = "About Us";

var textAlign = TextAlign.justify;
var style =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18);
double dataht = 140;
double datawt = 180;

card1() {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/gallery.png',
            height: dataht,
            width: datawt,
          ),
          Text(
            homePageTranslationText[0],
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Color(0xff018abd),
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ),
  );
}

card2() {
  setLanguageText();

  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/heatmap.png',
            height: dataht,
            width: datawt,
          ),
          Text(
            homePageTranslationText[1],
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Color(0xff018abd),
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ),
  );
}

card3() {
  setLanguageText();

  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/feedback.png',
            height: dataht,
            width: datawt,
          ),
          Text(
            homePageTranslationText[2],
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Color(0xff018abd),
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ),
  );
}

card4() {
  setLanguageText();

  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/board.png',
            height: dataht,
            width: datawt,
          ),
          Text(
            homePageTranslationText[3],
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Color(0xff018abd),
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ),
  );
}

aboutuscard() {
  setLanguageText();

  return Card(
    color: cardColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
    elevation: 10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: FaIcon(
          FontAwesomeIcons.infoCircle,
          size: 20,
        )),
        SizedBox(
          width: 20,
        ),
        Center(
          child: Text(homePageTranslationText[4],
              // aboutuscardtext,
              textAlign: textAlign,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
