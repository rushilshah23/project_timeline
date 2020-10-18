import 'package:flutter/material.dart';

class ReceivedUserModel {
  final String receivedUserEmailId;
  final String receivedUserUid;
  final String userId;

  ReceivedUserModel({
    @required this.receivedUserEmailId,
    @required this.userId,
    @required this.receivedUserUid,
  });
}
