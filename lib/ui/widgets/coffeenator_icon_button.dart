import 'package:flutter/material.dart';

class CoffeenatorIconButton extends StatelessWidget {
  const CoffeenatorIconButton({
    required this.icon,
    required this.onTap,
    this.buttonSize = 50,
    super.key,
  });

  final VoidCallback onTap;
  final IconData icon;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        shape: const CircleBorder(),
        color: Theme.of(context).colorScheme.primary,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          splashColor: Theme.of(context).colorScheme.primary,
          onTap: onTap,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
