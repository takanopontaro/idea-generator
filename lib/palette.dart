import 'package:flutter/material.dart';

const transparent = Colors.transparent;
const canvas = Color(0xfff4f5ec);
const brand = Color(0xff322f2d);
const dimBrand = Color(0xff4D4845);
const darkBrand = Color(0xff202020);
const lightBrand = Color(0xff6f6d6c);
const red = Color(0xfff53d3d);
const orange = Color(0xffF17E21);
const gray = Color(0xffD4D5CC);
const dimGray = Color(0xffEAEBE1);
const darkGray = Color(0xffb2b2b2);
const white = Color(0xffffffff);
const dimWhite = Color(0xff8E8E93);
const black = Color(0xff000000);
const inputIcon = InputIconColor();
const checkbox = CheckboxColor();

class InputIconColor extends MaterialStateColor {
  const InputIconColor() : super(0xff8E8E93);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.focused)) {
      return orange;
    }
    if (states.contains(MaterialState.disabled)) {
      return dimBrand;
    }
    return dimWhite;
  }
}

class CheckboxColor extends MaterialStateColor {
  const CheckboxColor() : super(0xff8E8E93);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return orange;
    }
    return Colors.grey;
  }
}
