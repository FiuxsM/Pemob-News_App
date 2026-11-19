import 'package:dio/dio.dart';

import '../config/env.dart';
import 'error_messages.dart';

/// Satu-satunya jenis error yang dilihat UI. `toString()` = pesan untuk pengguna.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => // baru di dio 5.10.0
        ApiException(ErrorMessages.timeout),
      DioExceptionType.connectionError =>
        ApiException(ErrorMessages.noConnection),
      DioExceptionType.badCertificate =>
        ApiException(ErrorMessages.badCertificate),
      DioExceptionType.cancel => ApiException(ErrorMessages.cancelled),
      DioExceptionType.badResponse => _dariResponse(e.response),
      DioExceptionType.unknown => ApiException(
          ErrorMessages.unexpected(Env.samarkan(e.message ?? '-')),
        ),
    };
  }

  /// GNews mengirim {"errors": ["pesan"]} atau {"errors": {"q": "pesan"}}
  static ApiException _dariResponse(Response<dynamic>? response) {
    final code = response?.statusCode;
    final pesanServer = _ambilPesanServer(response?.data);
    final pesan = switch (code) {
      400 => '${ErrorMessages.badRequest} ${pesanServer ?? ''}',
      401 => ErrorMessages.apiKeyInvalid,
      403 => ErrorMessages.quotaOrUnverified,
      404 => ErrorMessages.notFound,
      429 => ErrorMessages.tooManyRequests,
      final c? when c >= 500 => ErrorMessages.serverError(c),
      _ => ErrorMessages.unknownStatus(code),
    };
    return ApiException(pesan.trim(), statusCode: code);
  }

  static String? _ambilPesanServer(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is List && errors.isNotEmpty) return errors.first.toString();
    if (errors is Map && errors.isNotEmpty) return errors.values.first.toString();
    return null;
  }

  @override
  String toString() => message;
}
