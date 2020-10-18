import 'package:flutter/material.dart';

const carousel1 = BoxDecoration(
  borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40)),
  image: DecorationImage(
      image: NetworkImage(
          'https://www.iahv.org/in-en/wp-content/uploads/2019/02/17.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken)),
);

const carousel2 = BoxDecoration(
  borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40)),
  image: DecorationImage(
      image: NetworkImage(
          'https://www.iahv.org/in-en/wp-content/uploads/2019/02/130608-Save-water-save-Bengaluru-012.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken)),
);

const boxdeco1 = BoxDecoration(
    // borderRadius: BorderRadius.only(
    //     bottomLeft: Radius.circular(30),
    //     bottomRight: Radius.circular(30),
    //     topLeft: Radius.circular(30),
    //     topRight: Radius.circular(30)),
    shape: BoxShape.circle);

// String language;
