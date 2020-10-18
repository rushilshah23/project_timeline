import 'package:Aol_docProvider/core/models/receivedusermodel.dart';
import 'package:Aol_docProvider/ui/screens/home/shareddrive.dart';
import 'package:flutter/material.dart';

class ReceivedModelListTile extends StatefulWidget {
  final ReceivedUserModel receivedUserModel;
  ReceivedModelListTile({@required this.receivedUserModel});
  @override
  _ReceivedModelListTileState createState() => _ReceivedModelListTileState();
}

class _ReceivedModelListTileState extends State<ReceivedModelListTile> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(Icons.person),
          SizedBox(
            width: 50,
          ),
          Text(widget.receivedUserModel.receivedUserEmailId),
        ],
      ),
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ShareDrivePage(
            receivedUserModel: widget.receivedUserModel,
          );
        }));
      },
    );
  }
}
