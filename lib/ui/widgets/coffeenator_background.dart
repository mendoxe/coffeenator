import 'package:flutter/material.dart';

class CoffeenatorBackground extends StatelessWidget {
  const CoffeenatorBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: child,
      ),
    );
  }
}
