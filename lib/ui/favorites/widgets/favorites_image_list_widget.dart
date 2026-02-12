import 'package:cofeenator/cubit/local_image/local_image_cubit.dart';
import 'package:cofeenator/cubit/local_image/local_image_state.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/ui/favorites/widgets/favorites_image_card.dart';
import 'package:cofeenator/ui/widgets/coffeenator_error_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:cofeenator/ui/widgets/fading_page_view.dart';
import 'package:cofeenator/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesImageListWidget extends StatelessWidget {
  const FavoritesImageListWidget({required this.imageHashes, super.key});

  final List<String> imageHashes;

  @override
  Widget build(BuildContext context) {
    return FadingPageView(
      itemCount: imageHashes.length,
      itemBuilder: (context, index) {
        final imageHash = imageHashes[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocProvider(
            create: (context) {
              final cubit = LocalImageCubit(
                context.read<LocalImageRepository>(),
                imageHash: imageHash,
              );
              cubit.loadImage();

              return cubit;
            },
            child: BlocConsumer<LocalImageCubit, LocalImageState>(
              builder: (context, state) {
                return switch (state) {
                  LocalImageStateInitial() || LocalImageStateLoading() =>
                    const Center(child: CoffeenatorLoadingSpinner()),
                  LocalImageStateError() => const CoffeenatorErrorWidget(),
                  LocalImageStateLoaded(:final bytes) => FavoritesImageCard(
                    onActionButtonClick: () async {
                      final isDeleted = await context
                          .read<LocalImageCubit>()
                          .deleteCurrentImage();
                      if (isDeleted) {
                        if (!context.mounted) return;
                        context.read<LocalImageListCubit>().loadAll();
                      }
                    },
                    bytes: bytes,
                  ),
                };
              },
              listener: (context, state) {
                if (state is LocalImageStateError) {
                  context.showSnackBar(
                    'Something went wrong.',
                    type: SnackBarType.error,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
