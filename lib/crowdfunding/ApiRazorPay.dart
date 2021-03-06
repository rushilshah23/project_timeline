import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_timeline/languages/rawText/donationPageTranslation/donationPageTranslationTextEnglish.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'OrderApi.dart';
import 'SuccesPage.dart';

class ApiRazorPay extends StatefulWidget {
  String projectname;

  ApiRazorPay(String _projectname) {
    this.projectname = _projectname;
  }

  @override
  _ApiRazorPayState createState() => _ApiRazorPayState(projectname);
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String recoprojectname;
String amount;
double amt;
String idd;
String paymentId;
bool _autoValidate = false;
String _email;
String _mobile;
bool greaterthan10000 = false;
String selectedProject;

final TextEditingController _emailController = TextEditingController();
final TextEditingController _numberController = TextEditingController();
final TextEditingController _amountController = TextEditingController();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _pancardController = TextEditingController();
final TextEditingController _mynameController = TextEditingController()
  ..text = "Anonymous";
DropdownMenuItem abc = DropdownMenuItem(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('\nAny Project'),
      Text('   '),
      Divider(
        thickness: 2,
        color: Colors.grey[300],
      ),
    ],
  ),
  value: "Any Project",
);

Future<OrderApi> createOrder(String amount, String id,
    {String currency = "INR", String receipt = "receipt"}) async {
  final String apiUrls = "https://api.razorpay.com/v1/orders";
//  Map<String,String> myHeaders = new Map<String,String>();
  Map<String, String> myHeaders = {
//    "Content-Type": "application/json",
    "Authorization":
        "Basic cnpwX3Rlc3RfNzg1aXVIaEV3dGhPY2k6YUdFWmxvQ2hlbzR5NjhEMjhlYkxvMXha",
  };

  final response = await http.post(apiUrls, headers: myHeaders, body: {
    "amount": (num.parse(amount) * 100).toString(),
    "currency": currency,
    "receipt": receipt,
  });
  final String responseString = response.body;

  id = responseString.substring(7, 27);
  Map responsejson = jsonDecode(response.body.toString());
  idd = responsejson["id"];
  amt = responsejson["amount"] / 100;
  return orderApiFromJson(responseString);
}

class _ApiRazorPayState extends State<ApiRazorPay> {
  static const platform = const MethodChannel("razorpay_flutter");
  bool valuefirst = false;
  Razorpay _razorpay1;
  final databaseReference = FirebaseDatabase.instance.reference();

  List<DropdownMenuItem> projectsDropdwnItems = [abc];

  Future<void> getProjectsData() async {
    databaseReference
        .child("projects")
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map projMap = dataSnapshot.value;
      projMap.values.toList().forEach((result) {
        setState(() {
          Map resultMap = result;
          projectsDropdwnItems.add(
            DropdownMenuItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result['projectName']),
                  Text(
                    result['siteAddress'],
                    style: TextStyle(color: Colors.grey),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              value: result['projectName'],
            ),
          );
        });
      });
    });
  }

  String projectname;
  bool projectnameknown = false;

  _ApiRazorPayState(String _projectname) {
    this.projectname = _projectname;
    if (projectname != null) {
      projectnameknown = true;
    } else {
      projectnameknown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            toolbarHeight: 70,
            collapsedHeight: 90,
            //collapsedHeight: 100,
            backgroundColor: Colors.transparent,
            expandedHeight: 300,
            floating: true,
            pinned: false,
            // AppBar will get scrolled.
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45)),
                child: Image.asset(
                  "assets/test.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              titlePadding: EdgeInsets.fromLTRB(80, 0, 0, 35),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      donationPageTranslation[0],
                      style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: 31,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          valuefirst
                              ? TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: _mynameController,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff02b9f3),
                                        ),
                                      ),
                                      labelText: donationPageTranslation[1],
                                      hintText: donationPageTranslation[1]),
                                  enabled: false,
                                )
                              : TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff02b9f3),
                                        ),
                                      ),
                                      labelText: donationPageTranslation[1],
                                      hintText: donationPageTranslation[1]),
                                  validator: (String arg) {
                                    if (arg.length < 3)
                                      return donationPageTranslation[2];
                                    else if (arg.length > 20) {
                                      return donationPageTranslation[3];
                                    } else
                                      return null;
                                  },
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                checkColor: Colors.black,
                                value: this.valuefirst,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.valuefirst = value;
                                  });
                                },
                              ),
                              Text(donationPageTranslation[4])
                            ],
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff02b9f3),
                                  ),
                                ),
                                labelText: donationPageTranslation[5],
                                hintText: donationPageTranslation[5]),
                            validator: validateEmail,
                            onSaved: (String val) {
                              _email = val;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _numberController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff02b9f3),
                                  ),
                                ),
                                labelText: donationPageTranslation[6],
                                hintText: donationPageTranslation[6]),
                            keyboardType: TextInputType.phone,
                            validator: validateMobile,
                            onSaved: (String val) {
                              _mobile = val;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff02b9f3),
                                  ),
                                ),
                                labelText: donationPageTranslation[7],
                                hintText: donationPageTranslation[8]),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (num.parse(value) >= 10000) {
                                setState(() {
                                  greaterthan10000 = true;
                                });
                              } else {
                                setState(() {
                                  greaterthan10000 = false;
                                });
                              }
                            },
                            validator: (String value) {
                              if (value.isEmpty || num.parse(value) > 500000) {
                                return donationPageTranslation[9];
                              } else {
                                amount = value;
                                return null;
                              }
                            },
                          ),
                          greaterthan10000
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      validator: validatePAN,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      controller: _pancardController,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xff02b9f3),
                                            ),
                                          ),
                                          labelText:
                                              donationPageTranslation[10],
                                          hintText:
                                              donationPageTranslation[10]),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 20,
                                ),
                          projectnameknown
                              ? TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      enabled: false,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff02b9f3),
                                        ),
                                      ),
                                      labelText: projectname,
                                      labelStyle: TextStyle(
                                          fontSize: 25, color: Colors.black)),
                                )
                              : Container(
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff02b9f3),
                                        ),
                                      ),
                                    ),
                                    items: projectsDropdwnItems,
                                    onChanged: (selectedAccountType) {
                                      setState(() {
                                        selectedProject = selectedAccountType;
                                      });
                                    },
                                    validator: (value) => value == null
                                        ? donationPageTranslation[11]
                                        : null,
                                    value: selectedProject,
                                    isDense: false,
                                    isExpanded: true,
                                    hint: Text(
                                      donationPageTranslation[12],
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 18),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 30),
                          Center(
                            child: FlatButton(
                              child: Container(
                                width: 300,
                                height: 50,
                                padding: EdgeInsets.all(15),
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xff018abd),
                                ),
                                child: Text(
                                  donationPageTranslation[13],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  final OrderApi order =
                                      await createOrder('$amount', idd);
                                  openCheckout();
                                } else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                                //openCheckout();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: 1),
          ),
        ],
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return donationPageTranslation[14];
    else
      return null;
  }

  String validatePAN(String value) {
    Pattern pattern = "[A-Z]{5}[0-9]{4}[A-Z]{1}";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return donationPageTranslation[15];
    else
      return null;
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return donationPageTranslation[16];
    else
      return null;
  }

  @override
  void initState() {
    _nameController.clear();
    _emailController.clear();
    _amountController.clear();
    _numberController.clear();
    _pancardController.clear();
    super.initState();
    getProjectsData();
    _razorpay1 = Razorpay();
    _razorpay1.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay1.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay1.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay1.clear();
  }

  void openCheckout() async {
    _formKey.currentState?.reset();
    var options = {
      "order_id": idd,
      'key': 'rzp_test_785iuHhEwthOci',
      'name': 'IAHV',
      'description': 'Watershed Management Project',
      'prefill': {
        'contact': num.parse(_numberController.text),
        'email': _emailController.text.toString()
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay1.open(options);
    } catch (e) {}
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
    paymentId = response.paymentId.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SuccessPage(
                idd,
                paymentId,
                amt,
                valuefirst
                    ? _mynameController.text.toString()
                    : _nameController.text.toString(),
                _emailController.text.toString(),
                _numberController.text.toString(),
                greaterthan10000 ? _pancardController.text.toString() : 'null',
                projectnameknown ? projectname : selectedProject)));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }
}
