import 'package:flutter/material.dart';

class ReceivedUserModel {
  final String receivedUserEmailId;
  final String receivedUserUid;
  final String userId;
  // final String receivedUserPhoneNo;

  ReceivedUserModel({
    @required this.receivedUserEmailId,
    @required this.userId,
    @required this.receivedUserUid,
    // @required this.receivedUserPhoneNo,
  });
}
