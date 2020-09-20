import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/Register.dart';
import 'CommonWidgets.dart';
import 'manager/ManagerHomePage.dart';
import 'supervisor/SupervisorHomePage.dart';
import 'worker/WorkerHomePage.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();


}

class LoginPageState extends State<LoginPage> {
  String _email;
  String _password;

  List<String> _users = [
    'manager.aol@gmail.com',
    'supervisor@gmail.com',
    'worker1@gmail.com',
  ];
  int b = 1234;

  final formKey = new GlobalKey<FormState>();
  //final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();

  login() {
    if (_email.contains(_users[0]) &&
        _email != (_users[1]) &&
        _email != (_users[2])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ManagerHomePage()),
      );
    } else if (_email != (_users[0]) &&
        _email.contains(_users[1]) &&
        _email != (_users[2])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SupervisorHomePage()),
      );
    } else if (_email != _users[0] &&
        _email != _users[1] &&
        _email.contains(_users[2])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerHomePage()),
      );
    } else {
      showToast("Invalid Credentials");
    }
  }


  @override

  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                gradient: gradients(),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(100)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    //height: 50,
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10),
                        ]),
                    child: TextFormField(
                      controller: userController,
                      onChanged: (value) {
                        _email = value;
                      },
                      validator: (val) => val.isEmpty ? 'Enter email' : null,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    //height: 50,
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10),
                        ]),
                    child: TextFormField(
                      controller: passController,
                      validator: (val) => val.isEmpty ? 'Enter password' : null,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FlatButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        login();
                      }
                    },

                    child: buttonContainers(300, 20, 'Login', 18)
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Don't have an account?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue[900]
                            ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }
}

