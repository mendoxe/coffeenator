import 'package:cofeenator/cubit/discover_image/discover_image_cubit.dart';
import 'package:cofeenator/cubit/discover_image/discover_image_cubit_state.dart';
import 'package:cofeenator/ui/discover/widgets/discover_image_list_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:cofeenator/utils/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: BlocBuilder<DiscoverImageCubit, DiscoverImageCubitState>(
            builder: (context, state) {
              return switch (state) {
                DiscoverImageCubitStateInitial() => const Center(
                  child: CoffeenatorLoadingSpinner(),
                ),
                DiscoverImageCubitStateError(:final images, :final message) =>
                  DiscoverImageListWidget(
                    errorMessage: message,
                    images: images,
                  ),
                DiscoverImageCubitStateLoading(:final images) =>
                  DiscoverImageListWidget(
                    isLoading: true,
                    images: images,
                  ),
                DiscoverImageCubitStateLoaded(:final images) =>
                  DiscoverImageListWidget(
                    images: images,
                  ),
              };
            },
          ),
        ),

        Text(
          'SWIPE TO BROWSE NEXT BLEND',
          textAlign: TextAlign.center,
          style:
              Theme.of(
                context,
              ).textTheme.labelMedium.bold?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }
}
