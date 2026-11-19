import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/api_exception.dart';
import 'package:news_app/services/error_messages.dart';

DioException _badResponse(int code, [dynamic data]) {
  final req = RequestOptions(path: '/search');
  return DioException(
    requestOptions: req,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(requestOptions: req, statusCode: code, data: data),
  );
}

DioException _tipe(DioExceptionType type) =>
    DioException(requestOptions: RequestOptions(path: '/search'), type: type);

void main() {
  group('ApiException', () {
    test('status HTTP dipetakan ke pesan yang sesuai', () {
      expect(ApiException.fromDio(_badResponse(401)).message,
          ErrorMessages.apiKeyInvalid);
      expect(ApiException.fromDio(_badResponse(403)).message,
          ErrorMessages.quotaOrUnverified);
      expect(ApiException.fromDio(_badResponse(429)).message,
          ErrorMessages.tooManyRequests);
      expect(ApiException.fromDio(_badResponse(503)).message,
          ErrorMessages.serverError(503));
    });

    test('400 menyertakan pesan dari server', () {
      final e = ApiException.fromDio(_badResponse(400, {
        'errors': {'q': 'q kosong'}
      }));
      expect(e.message, '${ErrorMessages.badRequest} q kosong');
    });

    test('timeout dan koneksi memakai pesan berbeda', () {
      expect(ApiException.fromDio(_tipe(DioExceptionType.receiveTimeout)).message,
          ErrorMessages.timeout);
      expect(ApiException.fromDio(_tipe(DioExceptionType.connectionError)).message,
          ErrorMessages.noConnection);
    });

    test('minimal empat pesan error berbeda', () {
      final pesan = {
        ApiException.fromDio(_badResponse(401)).message,
        ApiException.fromDio(_badResponse(429)).message,
        ApiException.fromDio(_tipe(DioExceptionType.connectionError)).message,
        ApiException.fromDio(_tipe(DioExceptionType.receiveTimeout)).message,
        ErrorMessages.invalidFormat,
      };
      expect(pesan.length, greaterThanOrEqualTo(4));
    });
  });

  group('ArticleModel', () {
    test('fromJson memetakan field GNews dan merapikan content', () {
      final a = ArticleModel.fromJson({
        'title': 'Judul',
        'description': 'Ringkasan',
        'content': 'Isi berita [988 chars]',
        'url': 'https://contoh.id/a',
        'image': 'https://contoh.id/a.jpg',
        'publishedAt': '2026-11-18T00:30:00Z',
        'source': {'name': 'detikcom'},
      });
      expect(a.author, 'detikcom');
      expect(a.urlToImage, 'https://contoh.id/a.jpg');
      expect(a.content, 'Isi berita...');
    });
  });
}
