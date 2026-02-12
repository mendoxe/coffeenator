import 'dart:typed_data';

import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class _MockHttpClient extends Mock implements http.Client {}

void main() {
  group('RemoteImageRepository', () {
    late http.Client client;
    late RemoteImageRepository repository;

    setUp(() {
      client = _MockHttpClient();
      repository = RemoteImageRepository(client: client);
    });

    group('getImage', () {
      final uri = Uri.parse('https://coffee.alexflipnote.dev/random');
      final fakeBytes = Uint8List.fromList([1, 2, 3]);

      test('returns image bytes on successful response', () async {
        when(() => client.get(uri)).thenAnswer(
          (_) async => http.Response.bytes(fakeBytes, 200),
        );

        final result = await repository.getImage();

        expect(result, equals(fakeBytes));
        verify(() => client.get(uri)).called(1);
      });

      test('throws when http client throws', () {
        when(() => client.get(uri)).thenThrow(Exception('network error'));

        expect(() => repository.getImage(), throwsException);
      });
    });

    test('can be constructed with default client', () {
      expect(RemoteImageRepository.new, returnsNormally);
    });
  });
}
