import 'package:cofeenator/utils/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';

class CoffeenatorButton extends StatelessWidget {
  const CoffeenatorButton({
    required this.onTap,
    required this.label,
    this.icon,
    super.key,
  });

  final VoidCallback onTap;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: Theme.of(context).colorScheme.primary,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              if (icon case final IconData nonNullIcon)
                Icon(
                  nonNullIcon,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              Text(
                label,
                style: TextTheme.of(context).bodyLarge.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
