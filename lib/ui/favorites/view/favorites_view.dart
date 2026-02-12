import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/ui/favorites/widgets/favorites_image_list_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_error_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:cofeenator/utils/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalImageListCubit, LocalImageListState>(
      builder: (context, state) {
        return switch (state) {
          LocalImageListStateLoading() || LocalImageListStateInitial() => const Center(child: CoffeenatorLoadingSpinner()),
          LocalImageListStateError() => const CoffeenatorErrorWidget(),
          LocalImageListStateLoaded(:final imageHashes) when imageHashes.isEmpty => Center(
            child: Text(
              'Nothing saved yet, go ahead and save some images!',
              style: Theme.of(context).textTheme.bodyLarge.bold,
              textAlign: TextAlign.center,
            ),
          ),
          LocalImageListStateLoaded(:final imageHashes) => FavoritesImageListWidget(
            key: ValueKey(imageHashes),
            imageHashes: imageHashes,
          ),
        };
      },
    );
  }
}
