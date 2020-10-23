import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
DatabaseReference globalRef = _firebaseDatabase.reference();
DatabaseReference shareRef = _firebaseDatabase.reference();
DatabaseReference receiveRef = _firebaseDatabase.reference();

String globalPath;
