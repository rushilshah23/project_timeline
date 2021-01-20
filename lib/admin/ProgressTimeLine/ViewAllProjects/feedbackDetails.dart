import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/languages/setLanguageText.dart';


class FeedBackDetails extends StatefulWidget {
  final Map feedBackData;
  FeedBackDetails({
    Key key,
    this.feedBackData,
  }) : super(key: key);

  @override
  _FeedBackDetailsState createState() => _FeedBackDetailsState();
}

class _FeedBackDetailsState extends State<FeedBackDetails> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 1.7,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
        child: Form(
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: titleStyles(proText[22], 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(proText[17] + widget.feedBackData["name"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(proText[23] +
                      widget.feedBackData["groundwater level before"]
                          .toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(proText[24] +
                      widget.feedBackData["groundwater level after"]
                          .toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(proText[25] +
                      widget.feedBackData["crop production before"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(proText[26] +
                      widget.feedBackData["crop production after"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(proText[27] +
                      widget.feedBackData["feedback"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(proText[28] +
                      widget.feedBackData["suggestions"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
