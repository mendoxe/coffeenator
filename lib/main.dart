import 'package:cofeenator/coffeenator_app.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:cofeenator/utils/hive_paths.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final localImageBox = await Hive.openBox<String>(
    HivePaths.localImagesRepositoryBoxKey,
  );

  final localImageRepository = LocalImageRepository(localImageBox);
  final remoteImageRepository = RemoteImageRepository();

  runApp(
    CoffeenatorApp(
      localImageRepository: localImageRepository,
      remoteImageRepository: remoteImageRepository,
    ),
  );
}
