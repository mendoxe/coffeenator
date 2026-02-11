import 'package:flutter/material.dart';

class CoffeenatorLoadingSpinner extends StatelessWidget {
  const CoffeenatorLoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
