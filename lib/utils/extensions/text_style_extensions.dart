import 'package:flutter/material.dart';

extension TextStyleExtensions on TextStyle? {
  TextStyle? get bold => this?.copyWith(fontWeight: FontWeight.bold);
  TextStyle? get w700 => this?.copyWith(fontWeight: FontWeight.w700);
  TextStyle? get w600 => this?.copyWith(fontWeight: FontWeight.w600);
  TextStyle? get w500 => this?.copyWith(fontWeight: FontWeight.w500);
  TextStyle? get w400 => this?.copyWith(fontWeight: FontWeight.w400);
  TextStyle? get w300 => this?.copyWith(fontWeight: FontWeight.w300);
}
