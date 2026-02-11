import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class RemoteImageRepository {
  RemoteImageRepository({http.Client? client, Logger? logger}) //
    : _logger = logger ?? Logger(),
      _client = client ?? http.Client();

  static const _randomImageApiUrl = 'https://coffee.alexflipnote.dev/random';

  final http.Client _client;
  final Logger _logger;

  /// Fetches a new random image from API
  Future<Uint8List> getImage() async {
    _logger.t('Api call for new random image');
    final uri = Uri.parse(_randomImageApiUrl);
    final response = await _client.get(uri);
    _logger.t('New random image from Api received');
    return response.bodyBytes;
  }
}
