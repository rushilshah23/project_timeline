import 'package:flutter/material.dart';

class WorkerForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form"),
      ),
      body: WorkerFormPage(),
    );
  }
}

class WorkerFormPage extends StatefulWidget {
  @override
  _WorkerFormPageState createState() => _WorkerFormPageState();
}

class _WorkerFormPageState extends State<WorkerFormPage> {
  List<String> machines = ['A', 'B', 'C', 'D'];
  String selectedMachine;
  String hoursWorked, depth, length, upperWidth, lowerWidth;
  final _formKey = GlobalKey<FormState>();
  TextEditingController hoursWorkedController = TextEditingController();
  TextEditingController depthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController upperWidthController = TextEditingController();
  TextEditingController lowerWidthController = TextEditingController();

  void submitForm() {
    if (_formKey.currentState.validate()) {
      setState(() {
        hoursWorked = hoursWorkedController.text;
        depth = depthController.text;
        length = lengthController.text;
        upperWidth = upperWidthController.text;
        lowerWidth = lowerWidthController.text;
      });
      print("Submitted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Worker Form',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButton(
                value: selectedMachine,
                hint: Text("Select Machine Used"),
                isExpanded: true,
                items: machines.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedMachine = val;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: hoursWorkedController,
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.length == 0) {
                    return "Please Enter Hours Worked";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Hours Worked",
                  border: OutlineInputBorder(),
                  hintText: "Enter Hours Worked",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: depthController,
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.length == 0) {
                    return "Please Enter Depth";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Depth",
                  border: OutlineInputBorder(),
                  hintText: "Enter Depth",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: lengthController,
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.length == 0) {
                    return "Please LengthController";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "LengthController",
                  border: OutlineInputBorder(),
                  hintText: "Enter LengthController",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: upperWidthController,
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.length == 0) {
                    return "Please Enter Upper Width";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Upper Width",
                  border: OutlineInputBorder(),
                  hintText: "Enter Upper Width",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: lowerWidthController,
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.length == 0) {
                    return "Please Enter Lower Width";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Lower Width",
                  border: OutlineInputBorder(),
                  hintText: "Enter Lower Width",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 60,
                child: RaisedButton(
                  onPressed: submitForm,
                  child: Text("Submit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
