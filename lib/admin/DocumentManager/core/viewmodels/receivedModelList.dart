import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/core/models/receivedusermodel.dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/home/shareddrive.dart';

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
          Text(widget.receivedUserModel.receivedUserEmailId ??
              widget.receivedUserModel.receivedUserUid ??
              'null'),
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
