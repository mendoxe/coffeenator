import 'dart:async';

import 'package:cofeenator/bloc/discover_image/discover_image_cubit.dart';
import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:cofeenator/ui/discover/view/discover_view.dart';
import 'package:cofeenator/ui/favorites/favorites_page.dart';
import 'package:cofeenator/ui/widgets/coffeenator_background.dart';
import 'package:cofeenator/ui/widgets/coffeenator_button.dart';
import 'package:cofeenator/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final remoteImageRepository = context.read<RemoteImageRepository>();
        final cubit = DiscoverImageCubit(remoteImageRepository);
        unawaited(cubit.fetchImage());
        return cubit;
      },

      child: CoffeenatorBackground(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text('Discover'),
            actions: [
              CoffeenatorButton(
                onTap: () => context.navigateToPage<void>(const FavoritesPage()),
                icon: LineIcons.heartAlt,
                label: 'Favorites',
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: DiscoverView(),
          ),
        ),
      ),
    );
  }
}
