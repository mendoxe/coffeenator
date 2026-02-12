import 'dart:typed_data';

import 'package:cofeenator/ui/widgets/coffeenator_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class FavoritesImageCard extends StatelessWidget {
  const FavoritesImageCard({
    required this.onActionButtonClick,
    required this.bytes,
    super.key,
  });

  final Uint8List bytes;
  final VoidCallback onActionButtonClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.memory(
                bytes,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        CoffeenatorIconButton(
          buttonSize: 60,
          icon: LineIcons.heartBroken,
          onTap: onActionButtonClick,
        ),
      ],
    );
  }
}
