import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:cofeenator/theme/coffeenator_theme.dart';
import 'package:cofeenator/ui/discover/discover_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeenatorApp extends StatelessWidget {
  const CoffeenatorApp({
    required LocalImageRepository localImageRepository,
    required RemoteImageRepository remoteImageRepository,
    super.key,
  }) : _localImageRepository = localImageRepository,
       _remoteImageRepository = remoteImageRepository;

  final LocalImageRepository _localImageRepository;
  final RemoteImageRepository _remoteImageRepository;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _localImageRepository),
          RepositoryProvider.value(value: _remoteImageRepository),
        ],
        child: BlocProvider(
          create: (context) {
            final cubit = LocalImageListCubit(_localImageRepository)..loadAll();

            return cubit;
          },
          child: MaterialApp(
            theme: CoffeenatorTheme.defaultTheme,
            home: const DiscoverPage(),
          ),
        ),
      ),
    );
  }
}
