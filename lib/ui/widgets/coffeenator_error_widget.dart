import 'package:cofeenator/utils/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';

class CoffeenatorErrorWidget extends StatelessWidget {
  const CoffeenatorErrorWidget({this.errorMessage, super.key});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ups, something went wrong.',
      style: Theme.of(context).textTheme.bodyLarge.bold,
      textAlign: TextAlign.center,
    );
  }
}
