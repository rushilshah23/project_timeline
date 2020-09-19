import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';
import 'package:project_timeline/sms/my_twilio.dart';



Future<void> sms(String s,String msg) async {
  // See http://twil.io/secure for important security information
  var _accountSid = Platform.environment['TWILIO_ACCOUNT_SID'];
  var _authToken = Platform.environment['TWILIO_AUTH_TOKEN'];

  // Your Account SID and Auth Token from www.twilio.com/console
  // You can skip this block if you store your credentials in environment variables
  _accountSid ??= 'ACf79c696f7ee1cb277b2e7b563128fff9';
  _authToken ??= 'bae5a5e871347a7c1e23ee0162b028e6';

  // Create an authenticated client instance for Twilio API
  var client = new MyTwilio(_accountSid, _authToken);
  String no = '+91' + s;
  // Send a text message
  // Returns a Map object (key/value pairs)
  Map message = await client.messages.create({
    'body': msg,
    'from': '+17743325609', // a valid Twilio number
    'to': no // your phone number
  });

  // access individual properties using the square bracket notation
  // for example print(message['sid']);
  print(message);
}

void main()
{
  runApp(Sms());
}


class Sms extends StatefulWidget {
  @override
  _SmsState createState() => _SmsState();
}

class _SmsState extends State<Sms> {



  String mobileNo = '';
  var mobileNoControl = new TextEditingController();
  String message = '';
  var messageControl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 20),
          child: ListView(

            children: [
              SizedBox(height: 40),
              Center(child: titleStyles('SMS', 20)),
              SizedBox(height: 50),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Enter receiver's Mobile No. XXXXXXXXXX",
                    fillColor: Colors.white,
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    ),
                  ),
                  controller: mobileNoControl,
                  validator: (val) => val.isEmpty ? "Enter receiver's Mobile No." : null,
                  onChanged: (val){
                    setState(() => mobileNo = val);
                  },
                ),
              SizedBox(height: 35),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Enter message to be sent",
                  fillColor: Colors.white,
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                ),
                controller: messageControl,
                validator: (val) => val.isEmpty ? 'Enter message' : null,
                onChanged: (val){
                  setState(() => message = val);
                },
              ),
              SizedBox(height: 50),
              buttons(context, sms(mobileNo,message), 'Send SMS', 18)
            ],
          ),
        ),
      ),
    );
  }
}