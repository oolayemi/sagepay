import 'package:flutter/material.dart';

class SagePayUtils {
  static Color orangePrimary = hexToColor('#FF6600');
  static Color lightGrey = hexToColor('#8E8E93');
  static Color bgGrey = hexToColor('#F0EDEC');

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
