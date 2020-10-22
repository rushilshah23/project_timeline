
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ConfettiController.dart';


class SuccessPage extends StatefulWidget {
  double amount;
  String orderId;
  String paymentId;
  String donorName;
  String donorEmail;
  String donorPhoneNo;
  String donorPanCard;
  String proj;
  SuccessPage(String _orderId, String _paymentId, double _amount,String _name,String _email,String _phoneNo,String _panCard,String _selectedproject) {
    this.amount = _amount;
    this.orderId = _orderId;
    this.paymentId = _paymentId;
    this.donorName = _name;
    this.donorEmail = _email;
    this.donorPhoneNo = _phoneNo;
    this.donorPanCard = _panCard;
    this.proj = _selectedproject;
  }

  @override
  _SuccessPageState createState() => _SuccessPageState(orderId,paymentId,amount,donorName,donorEmail,donorPhoneNo,donorPanCard,proj);
}

class _SuccessPageState extends State<SuccessPage> {
  double amount;
  String orderId;
  String paymentId;
  String donorName;
  String donorEmail;
  String donorPhoneNo;
  String donorPanCard;
  String proj;
  _SuccessPageState(String _orderId, String _paymentId, double _amount,String _name,String _email,String _phoneNo,String _panCard,String _selectedproject) {
    this.amount = _amount;
    this.orderId = _orderId;
    this.paymentId = _paymentId;
    this.donorName = _name;
    this.donorEmail = _email;
    this.donorPhoneNo = _phoneNo;
    this.donorPanCard = _panCard;
    this.proj = _selectedproject;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();

  }
  int counter;
  int totalAmount;
  String name;
  String email;
  String phoneNo;
  String panCard;
  String identifer;
  void addData() async{
    var timeStamp = (DateFormat.yMd().add_jm().format(new DateTime.now()))
        .toString()
        .replaceAll('/', '_');
    print(paymentId + "              " + orderId + "             " +
        amount.toString()+"     "+timeStamp.toString());
    name = donorName;
    email = donorEmail;
    phoneNo = donorPhoneNo;
    panCard=donorPanCard;
    identifer=email.replaceAll(".", "-")+phoneNo;
    final databaseReference = FirebaseDatabase.instance.reference();


    try{
      await databaseReference.child('Donation').child('$identifer').child("details").once().then((DataSnapshot snap) {
        if(snap.value == null) {
          counter = 0;
          totalAmount = 0;
        } else {
          setState(() {
            counter = snap.value["noOfDonations"];
            totalAmount = snap.value["total"];
          });
       }
    });
    } catch(e) {
      print(e.toString());
    }

//    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
//    DatabaseReference databaseReference = firebaseDatabase.reference();
    try {
      DatabaseReference dr1=databaseReference.child('Donation').child('$identifer').child('donations').child( timeStamp.toString()).reference();
      databaseReference.child('Donation').child('$identifer').child('donations').child( timeStamp.toString()).set({
        "paymentId": paymentId,
        "orderId": orderId,
        "amount": amount,
        "Project":proj,
        'timestamp': timeStamp.toString(),
      });
      dr1.parent().parent().child('details').set({
        'name':name,
        'email':email,
        'phone_no':phoneNo,
        'panCard':panCard,
        'noOfDonations':counter+1,
        'total':totalAmount+amount,
      });
    } catch(e) {
      print(" check your internet");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            AllConfettWidget(
              child:Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/logo.png",
                                scale: 4,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Donation Successful   ",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      "assets/success.gif",
                                      scale: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Image.asset(
                            "assets/donate2.gif",
                            scale: 3,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Text(
                            "Thank You",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(
                                children: [
                                  Text(
                                    " Payment Id: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    " $paymentId",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text(
                                    " Order Id: ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    " $orderId",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text(
                                    " Amount Paid: ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    " $amount",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}