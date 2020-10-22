import 'package:carousel_slider/carousel_slider.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/AboutUs/MainPage/HomeScreen.dart';
import 'package:project_timeline/UserSide/Dashboard/Widgets/Couroselitems.dart';
import 'package:project_timeline/UserSide/Feedback/MainFeedbackPage/feedback.dart';
import 'package:project_timeline/UserSide/Gallery/HomePage.dart';
import 'package:project_timeline/UserSide/MultiLingual/mainPages/language.dart';
import 'package:project_timeline/UserSide/MultiLingual/pageTranslations/feedbackText.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:project_timeline/UserSide/UI/Widgets/cards.dart';
import 'package:project_timeline/crowdfunding/leaderBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _currentIndex;
  double cardClayContainerheight = 20;
  double cardClayContainerwidth = 20;

  bool feedback;
  SharedPreferences sharedPreferences;
  String language;

  @override
  void initState() {
    super.initState();
    loadTextFields();
  }

  // Language _languageHome;
  loadTextFields() async {
    sharedPreferences = await SharedPreferences.getInstance();
    language = sharedPreferences.getString('language');
    if (language != 'en') {
      for (var i = 0; i < feedbackText.length; i++) {
        await Language(language).getTranslation(feedbackText[i]).then((value) {
          setState(() {
            feedbackText[i] = value;
          });
        });
      }
    }

    // return text1 =
    //     (await _langVar.getTranslation('We serve the society')).toString();
  }

  List cardList = [Item1(), Item2()];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40))),
                    child: Column(children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 300,
                          aspectRatio: 3,
                          viewportFraction: 10,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: cardList.map((card) {
                          return Builder(builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(40),
                                      bottomLeft: Radius.circular(40))),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40))),
                                child: card,
                              ),
                            );
                          });
                        }).toList(),
                      ),
                    ])),
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              child: SizedBox(height: 20),
            )
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: 80,
                width: 50,
                // customBorderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(10),
                //     bottomRight: Radius.circular(10)),
                padding: EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                    color: commonBGColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: FlipCard(
                    onFlipDone: (isFront) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    flipOnTouch: true,
                    direction: FlipDirection.HORIZONTAL,
                    front: aboutuscard(),
                    back: aboutuscard())),
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              child: SizedBox(height: 20),
            )
          ])),
          SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
              ),
              delegate: SliverChildListDelegate([
                ClayContainer(
                  color: gridColor,
                  customBorderRadius:
                      BorderRadius.only(topLeft: Radius.circular(40)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: FlipCard(
                      onFlipDone: (isFront) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DbTesting()));
                      },
                      flipOnTouch: true,
                      direction: FlipDirection.HORIZONTAL,
                      front: card1(),
                      back: card1(),
                    ),
                  ),
                ),
                ClayContainer(
                  height: cardClayContainerheight,
                  width: cardClayContainerwidth,
                  color: gridColor,
                  customBorderRadius:
                      BorderRadius.only(topRight: Radius.circular(40)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: FlipCard(
                      onFlipDone: (isFront) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                      direction: FlipDirection.HORIZONTAL,
                      front: card2(),
                      back: card2(),
                    ),
                  ),
                ),
                ClayContainer(
                  color: gridColor,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: FlipCard(
                      onFlipDone: (isFront) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocalFeedback()));
                      },
                      direction: FlipDirection.HORIZONTAL,
                      front: card3(),
                      back: card3(),
                    ),
                  ),
                ),
                ClayContainer(
                  height: cardClayContainerheight,
                  width: cardClayContainerwidth,
                  color: gridColor,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: FlipCard(
                      onFlipDone: (isFront) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => leaderBoard()));
                      },
                      direction: FlipDirection.HORIZONTAL,
                      front: card4(),
                      back: card4(),
                    ),
                  ),
                ),
              ])),
        ]),
      ),
    );
  }
}
