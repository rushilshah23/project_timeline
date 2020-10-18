import 'package:flutter/material.dart';

Widget textFieldWidget(
    {@required TextEditingController controller,
    Function validateFunction,
    String labelText,
    String hintText,
    TextInputType keyboardType,
    bool obscure = false}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validateFunction,
    obscureText: obscure,
    decoration: InputDecoration(
      labelText: "$labelText",
      hintText: "$hintText",
      border: OutlineInputBorder(),
      fillColor: Color(0xff02deed),
    ),
  );
}
