import 'package:flutter/material.dart';



String machineType = 'One';
List<String> machineTypeSelected=List.generate(74, (i) => 'One');
List<TextEditingController> _machineQuantity = List.generate(74, (i) => TextEditingController());


class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();

  //Project Name
  String projectName = '';
  var projectNameControl = new TextEditingController();

  //Site Address
  String siteAddress = '';
  var siteAddressControl = new TextEditingController();

  //Soil Type
  var soilType;
  List<String> _soilType = <String>[
    'Soft',
    'Rough',
    'Rocky',
  ];

  //Length
  String length = '';
  var lenControl = new TextEditingController();

  //Depth
  String depth = '';
  var depControl = new TextEditingController();

  //Upper Width
  String upwidth = '';
  var upwidthControl = new TextEditingController();

  //Upper Width
  String lowidth = '';
  var lowidthControl = new TextEditingController();

  //supervisor
  var supervisor;
  List<String> _supervisor = <String>[
    'A',
    'B',
    'C',
  ];

  //petrolPump
  var petrolPump;
  List<String> _petrolPump = <String>[
    'Soft',
    'Rough',
    'Rocky',
  ];

  //Dynamic Fields
  List<DynamicWidget> listDyn = [];
  addDynamic(){
    listDyn.add(new DynamicWidget());
    setState(() {
    });
  }


  @override
  Widget _buildAboutDialog(BuildContext context, String l, String d, String uw, String lw) {
    double len = double.parse(l);
    double dep = double.parse(d);
    double uwi = double.parse(uw);
    double lwi = double.parse(lw);
    double calc = 0.5 * len * dep * (uwi + lwi);
    return new AlertDialog(
        title: const Text('Project Timeline'),
        content: RichText(
          text: new TextSpan(
            text: 'Duration:\n\nMachinery:\n\nCost of Fuel:\n\nVolume to be excavated: $calc\n\n\n\n',
            style: const TextStyle(color: Colors.black87),
            children: <TextSpan>[
              const TextSpan(text: 'Do you want to create project?'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Create Project'),
          ),
        ]);
  }




  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Text("Create Project",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        body: Form(
          key: _formKeyValue,
          //autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            children: <Widget>[

              Center(child:
              Text(
                'Create New Project',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Project Name",
                  fillColor: Colors.white,
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                ),
                controller: projectNameControl,
                validator: (val) => val.isEmpty ? 'Enter project name' : null,
                onChanged: (val){
                  setState(() => projectName = val);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Site Address",
                  fillColor: Colors.white,
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                ),
                controller: siteAddressControl,
                validator: (val) => val.isEmpty ? 'Enter site address' : null,
                onChanged: (val){
                  setState(() => siteAddress = val);
                },
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButton(
                    items: _soilType
                        .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.deepPurple[900]),
                      ),
                      value: value,
                    ))
                        .toList(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        soilType = selectedAccountType;
                      });
                    },
                    value: soilType,
                    isExpanded: true,
                    hint: Text(
                      'Select Soil Type',
                      style: TextStyle(color: Colors.black54,fontSize: 17),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //         <--- border radius here
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SELECT MACHINE TYPE',style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic)),
                        IconButton(
                          icon: Icon(Icons.add,color: Colors.indigo),
                          onPressed: addDynamic,
                        ),
                      ],
                    ),

                    Flexible(
                      fit: FlexFit.loose,
                      child: new ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: listDyn.length,
                        itemBuilder: (context,index) {
                          return DynamicWidget(index: index);
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //         <--- border radius here
                    ),
                  ),
                  child: Column(
                   // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PROJECT GOALS',style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: "Length",
                                fillColor: Colors.white,
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              controller: lenControl,
                              validator: (val) => val.isEmpty ? 'Enter project name' : null,
                              onChanged: (val){
                                setState(() => length = val);
                              },
                            ),
                          ),
                          SizedBox(width: 20.0,),
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: "Depth",
                                fillColor: Colors.white,
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              controller: depControl,
                              validator: (val) => val.isEmpty ? 'Enter project name' : null,
                              onChanged: (val){
                                setState(() => depth = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: "Upper Width",
                                fillColor: Colors.white,
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              controller: upwidthControl,
                              validator: (val) => val.isEmpty ? 'Enter project name' : null,
                              onChanged: (val){
                                setState(() => upwidth = val);
                              },
                            ),
                          ),
                          SizedBox(width: 20.0,),
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: "Lower Width",

                                fillColor: Colors.white,
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              controller: lowidthControl,
                              validator: (val) => val.isEmpty ? 'Enter project name' : null,
                              onChanged: (val){
                                setState(() => lowidth = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  )
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButton(
                    items: _supervisor
                        .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.deepPurple[900]),
                      ),
                      value: value,
                    ))
                        .toList(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        supervisor = selectedAccountType;
                      });
                    },
                    value: supervisor,
                    isExpanded: true,
                    hint: Text(
                      'Select Supervisor',
                      style: TextStyle(color: Colors.black54,fontSize: 17),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButton(
                    items: _petrolPump
                        .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.deepPurple[900]),
                      ),
                      value: value,
                    ))
                        .toList(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        petrolPump = selectedAccountType;
                      });
                    },
                    value: petrolPump,
                    isExpanded: true,
                    hint: Text(
                      'NearBy Petrol Pump',
                      style: TextStyle(color: Colors.black54,fontSize: 17),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              FlatButton(
                child: Text(
                  'Estimate Project',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: () {


                  for (int i = 0; i < listDyn.length; i++) {
                    debugPrint( _machineQuantity[i].text.toString());
                    debugPrint( machineTypeSelected[i].toString());
                  }

                  if(_formKeyValue.currentState.validate())
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildAboutDialog(context,length,depth,upwidth,lowidth),
                      );
                    }

                },
                color: Colors.purple[800],
              ),
            ],
          ),
        ));
  }
}

class DynamicWidget extends StatefulWidget {
  final int index;
  DynamicWidget({Key key, this.index}) : super(key: key);
  @override
  _DynamicWidgetState createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: DropdownButton<String>(
                value: machineTypeSelected[widget.index],
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.grey,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    machineTypeSelected[widget.index] = newValue;
                    debugPrint(widget.index.toString());
                  });
                },
                items: <String>['One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Flexible(
              child:TextFormField(
                controller: _machineQuantity[widget.index],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  fillColor: Colors.white,
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}