import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:flutter/material.dart';

import '../../CommonWidgets.dart';

String machineType = 'Select Machine';
List<String> machineTypeSelected=List.generate(74, (i) => 'Select Machine');
List<TextEditingController> _machineQuantity = List.generate(74, (i) => TextEditingController());

class CreateNewProject extends StatefulWidget {

  @override
  _CreateNewProjectState createState() => _CreateNewProjectState();
}

class _CreateNewProjectState extends State<CreateNewProject> {

  String pname = '';
  var pnameControl = new TextEditingController();
  String saddr = '';
  var saddrControl = new TextEditingController();
  String ssoil = '';
  var ssoilControl = new TextEditingController();
  var value;
  bool isExpanded = false;
  String dropdownValue = 'Select';
  String pump = 'Select';
  String supervisor = 'Select';
  List<DynamicWidget> listDyn = [];


  addDynamic(){
    listDyn.add(new DynamicWidget());
    setState(() {

    });
  }





  @override

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text: 'Duration:\n\nMachinery:\n\nCost of Fuel:\n\nVolume to be excavated:\n\n\n\n',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          const TextSpan(text: 'Do you want to create project?'),
        ],
      ),
    );
  }


  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Project Timeline'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Create Project'),
        ),
      ],
    );
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppbar("Add New Project"),
      body: ListView(
        children: [

          SizedBox(height: 20,),

          Center(child:
          Text(
            'Add New Project',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),),

          Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 25),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Project Name",
                    fillColor: Colors.white,
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    ),
                  ),
                  controller: pnameControl,
                  validator: (val) => val.isEmpty ? 'Enter project name' : null,
                  onChanged: (val){
                    setState(() => pname = val);
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Site Address",
                    fillColor: Colors.white,
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    ),
                  ),
                  controller: saddrControl,
                  validator: (val) => val.isEmpty ? 'Enter site address' : null,
                  onChanged: (val){
                    setState(() => saddr = val);
                  },
                ),
                SizedBox(height: 10),
                Material(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: GroovinExpansionTile(
                    defaultTrailingIconColor: Colors.indigoAccent,
                    title: Text(
                      'Select Site Soil Type',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(dropdownValue),
                    onExpansionChanged: (value) {
                      setState(() {
                        isExpanded = value;
                      });
                    },
                    inkwellRadius: !isExpanded
                        ? BorderRadius.all(Radius.circular(8.0))
                        : BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                    ),
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[


                                  ListTile(
                                    onTap: (){
                                      dropdownValue='Soft';
                                    },
                                    title: Text('Soft'),
                                  ),

                                  ListTile(
                                    onTap: (){
                                      dropdownValue='Rough';
                                    },
                                    title: Text('Rough'),
                                  ),

                                  ListTile(
                                    onTap: (){},
                                    title: Text('Hard'),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
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
                          itemBuilder: (context, index) {
                            return DynamicWidget(index:index);
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
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0) //         <--- border radius here
                      ),
                    ),
                    child: Column(
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
                                  )
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
                                  )
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
                                  )
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
                                  )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    )
                ),
                SizedBox(height: 10),
                Material(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: GroovinExpansionTile(
                    defaultTrailingIconColor: Colors.indigoAccent,
                    title: Text(
                      'Select Supervisor',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(supervisor),
                    onExpansionChanged: (value) {
                      setState(() {
                        isExpanded = value;
                      });
                    },
                    inkwellRadius: !isExpanded
                        ? BorderRadius.all(Radius.circular(8.0))
                        : BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                    ),
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[

                                  ListTile(
                                    onTap: (){
                                      supervisor='Rajesh Kumar';
                                    },
                                    title: Text('Rajesh Kumar'),
                                  ),

                                  ListTile(
                                    onTap: (){
                                      supervisor='Rahul Jain';
                                    },
                                    title: Text('Rahul Jain'),
                                  ),

                                  ListTile(
                                    onTap: (){
                                      supervisor='Shakti Lokhande';
                                    },
                                    title: Text('Shakti Lokhande'),
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Material(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: GroovinExpansionTile(
                    defaultTrailingIconColor: Colors.indigoAccent,
                    title: Text(
                      'Nearby Petrol Pump',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(pump),
                    onExpansionChanged: (value) {
                      setState(() {
                        isExpanded = value;
                      });
                    },
                    inkwellRadius: !isExpanded
                        ? BorderRadius.all(Radius.circular(8.0))
                        : BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                    ),
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[

                                  ListTile(
                                    onTap: (){
                                      pump='HP Petrol Pump';
                                    },
                                    title: Text('RHP Petrol Pump'),
                                  ),

                                  ListTile(
                                    onTap: (){
                                      pump='Hement Karkare Cng Station';
                                    },
                                    title: Text('Hement Karkare Cng Station'),
                                  ),

                                  ListTile(
                                    onTap: (){
                                      pump='Bharat Petroleum';
                                    },
                                    title: Text('Bharat Petroleum'),
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
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

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildAboutDialog(context),
                    );
                  },
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class DynamicWidget extends StatefulWidget {


  final int index;
  DynamicWidget({Key key, this.index}) : super(key: key);
  @override
  _DynamicWidgetState createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  String dropdownValue = 'Select Machine';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: DropdownButton<String>(
                value: machineTypeSelected[widget.index],
                //icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                //style: TextStyle(color: Colors.deepPurple),
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
                items: <String>['Select Machine','Crawler Excavators', 'Dragline Excavators', 'Suction Excavators', 'Skid Steer Excavators']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/4,
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