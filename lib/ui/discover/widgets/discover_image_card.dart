import 'dart:typed_data';

import 'package:cofeenator/cubit/save_image/save_image_cubit.dart';
import 'package:cofeenator/cubit/save_image/save_image_state.dart';
import 'package:cofeenator/ui/widgets/coffeenator_icon_button.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:cofeenator/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class DiscoverImageCard extends StatelessWidget {
  const DiscoverImageCard({
    required this.onDisliked,
    required this.onLiked,
    required this.bytes,
    super.key,
  });

  final Uint8List bytes;
  final VoidCallback onLiked;
  final VoidCallback onDisliked;

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
        BlocConsumer<SaveImageCubit, SaveImageState>(
          builder: (context, state) {
            return Center(
              child: SizedBox(
                height: 70,
                child: switch (state) {
                  SaveImageStateLoading() => const CoffeenatorLoadingSpinner(),
                  SaveImageStateSaved() => CoffeenatorIconButton(
                    buttonSize: 60,
                    icon: LineIcons.heartBroken,
                    onTap: onDisliked,
                  ),
                  _ => CoffeenatorIconButton(
                    buttonSize: 60,
                    icon: LineIcons.heartAlt,
                    onTap: onLiked,
                  ),
                },
              ),
            );
          },
          listener: (context, state) {
            if (state is SaveImageStateError) {
              context.showSnackBar(
                'Something went wrong.',
                type: SnackBarType.error,
              );
            }
          },
        ),
      ],
    );
  }
}
