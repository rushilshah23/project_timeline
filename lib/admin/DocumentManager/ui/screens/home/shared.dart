import 'package:Aol_docProvider/core/models/receivedusermodel.dart';
import 'package:Aol_docProvider/core/models/usermodel.dart';
import 'package:Aol_docProvider/core/services/database.dart';
import 'package:Aol_docProvider/core/viewmodels/file.dart';
import 'package:Aol_docProvider/core/viewmodels/folders.dart';
import 'package:Aol_docProvider/core/viewmodels/receivedModelList.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:Aol_docProvider/ui/widgets/loading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SharedPage extends StatefulWidget {
  @override
  _SharedPageState createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  DatabaseReference _shareRef;
  final FirebaseDatabase _fbdb = FirebaseDatabase.instance;
  List<FolderCard> folderModelList = [];
  List<FileCard> fileModelList = [];
  List<ReceivedModelListTile> receivedModelListTileCards = [];

  UserModel userModelVar;
  var receivedUserEmailid;
  void initState() {
    userModelVar = Provider.of<UserModel>(context, listen: false);

    _shareRef = _fbdb
        .reference()
        .child('shared')
        .child('users')
        .child(userModelVar.uid)
        .child('received')
        .reference();

    getReceivedUsersEmail();

    super.initState();
  }

  getUserEmailFromKey({String key}) async {
    receivedUserEmailid =
        await DatabaseService().getEmailIdfromUserId(userId: key);
  }

  Future<List<ReceivedModelListTile>> getReceivedUsersEmail() async {
    await _shareRef.once().then((DataSnapshot snapshot) async {
      receivedModelListTileCards.clear();

      if (snapshot.value != null) {
        try {
          var keys = snapshot.value.keys;

          receivedModelListTileCards.clear();

          for (var key in keys) {
            receivedUserEmailid =
                await DatabaseService().getEmailIdfromUserId(userId: key);
            setState(() {
              ReceivedUserModel receivedModelCard = new ReceivedUserModel(
                receivedUserEmailId: receivedUserEmailid,
                receivedUserUid: key,
                userId: userModelVar.uid,
              );

              receivedModelListTileCards.add(ReceivedModelListTile(
                receivedUserModel: receivedModelCard,
              ));
            });
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
    return receivedModelListTileCards;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
        stream: _shareRef.onValue,
        builder: (context, snapshot) {
          return snapshot.hasData && !snapshot.hasError
              ? Scaffold(
                  appBar: AppBar(
                    title: Text('Documents shared with you'),
                    backgroundColor: appColor,
                  ),
                  body: receivedModelListTileCards.length != 0
                      ? Container(
                          child: ListView(
                            children: [
                              ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      receivedModelListTileCards.length ?? 0,
                                  itemBuilder: (_, index) {
                                    return receivedModelListTileCards[index];
                                  })
                            ],
                          ),
                        )
                      : Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(50, 300, 50, 200),
                            child: Text(
                              'No Items',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: appColor),
                            ),
                          ),
                        ))
              : Loading();
        });
  }
}
