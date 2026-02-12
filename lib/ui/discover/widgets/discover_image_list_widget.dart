import 'dart:typed_data';

import 'package:cofeenator/cubit/discover_image/discover_image_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/save_image/save_image_cubit.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/ui/discover/widgets/discover_image_card.dart';
import 'package:cofeenator/ui/widgets/coffeenator_error_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:cofeenator/ui/widgets/fading_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverImageListWidget extends StatelessWidget {
  const DiscoverImageListWidget({
    required this.images,
    super.key,
    this.errorMessage,
    this.isLoading = false,
  });

  final List<Uint8List> images;
  final String? errorMessage;
  final bool isLoading;

  bool get hasError => errorMessage != null;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty && hasError) {
      return const Center(
        child: CoffeenatorErrorWidget(),
      );
    }

    if (images.isEmpty && isLoading) {
      return const Center(child: CoffeenatorLoadingSpinner());
    }

    return FadingPageView(
      itemCount: images.length + 1,
      onPageChanged: (page) async {
        if (page == images.length) {
          await context.read<DiscoverImageCubit>().fetchImage();
        }
      },
      itemBuilder: (context, index) {
        if (hasError && index == images.length) {
          return const Center(child: CoffeenatorErrorWidget());
        }
        if (index == images.length) {
          return const Center(child: CoffeenatorLoadingSpinner());
        }

        return BlocProvider(
          create: (context) {
            final cubit = SaveImageCubit(
              context.read<LocalImageRepository>(),
              imageBytes: images[index],
            );

            cubit.checkIfImageSaved();
            return cubit;
          },
          child: DiscoverImageCardWrapper(bytes: images[index]),
        );
      },
    );
  }
}

class DiscoverImageCardWrapper extends StatelessWidget {
  const DiscoverImageCardWrapper({
    required this.bytes,
    super.key,
  });

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return DiscoverImageCard(
      bytes: bytes,
      onDisliked: () async {
        await context.read<SaveImageCubit>().deleteCurrentImage();
        if (!context.mounted) return;
        context.read<LocalImageListCubit>().loadAll();
      },
      onLiked: () async {
        final isSaved = await context.read<SaveImageCubit>().saveCurrentImage();
        if (!context.mounted) return;
        if (isSaved) {
          context.read<LocalImageListCubit>().loadAll();
        }
      },
    );
  }
}
