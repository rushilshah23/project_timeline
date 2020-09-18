import './messages.dart' show Messages;

class MyTwilio {
  final String _accountSid;
  final String _authToken;

  const MyTwilio(this._accountSid, this._authToken);

  Messages get messages => Messages(_accountSid, _authToken);
}