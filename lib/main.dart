import 'package:cofeenator/bloc/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:cofeenator/theme/coffeenator_theme.dart';
import 'package:cofeenator/ui/discover/discover_page.dart';
import 'package:cofeenator/utils/hive_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final localImageBox = await Hive.openBox<String>(HivePaths.localImagesRepositoryBoxKey);

  final localImageRepository = LocalImageRepository(localImageBox);
  final remoteImageRepository = RemoteImageRepository();

  runApp(
    CoffeenatorApp(
      localImageRepository: localImageRepository,
      remoteImageRepository: remoteImageRepository,
    ),
  );
}

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
          create: (context) => LocalImageListCubit(_localImageRepository),
          child: MaterialApp(
            theme: CoffeenatorTheme.defaultTheme,
            home: const DiscoverPage(),
          ),
        ),
      ),
    );
  }
}
