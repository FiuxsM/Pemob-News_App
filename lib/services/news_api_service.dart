import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../models/article_model.dart';
import '../models/news_response_model.dart';
import 'api_exception.dart';
import 'error_messages.dart';

/// URL dan API key TIDAK ditulis di sini, tetapi dibaca dari [Env].
class NewsApiService {
  /// Satu instance dipakai bersama (satu Dio, satu konfigurasi).
  static final NewsApiService shared = NewsApiService();

  static const String _searchPath = '/search';

  final Dio _dio;

  NewsApiService({Dio? dio}) : _dio = dio ?? _buatDio();

  static Dio _buatDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        // Ikut di setiap request
        queryParameters: {
          'apikey': Env.apiKey,
          'lang': 'id',
          'country': 'id',
          'max': 10,
        },
      ),
    );

    // Log hanya saat mode debug, API key disamarkan menjadi ***
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        logPrint: (obj) => debugPrint(Env.samarkan(obj.toString())),
      ));
    }
    return dio;
  }

  /// Pencarian berita lewat endpoint `/search` (juga dipakai untuk tiap topik).
  Future<List<ArticleModel>> searchNews(String keyword) async {
    if (!Env.lengkap) {
      throw ApiException(ErrorMessages.configMissing);
    }
    try {
      final response = await _dio.get(
        _searchPath,
        queryParameters: {'q': keyword, 'sortby': 'publishedAt'},
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException(ErrorMessages.invalidFormat);
      }
      return NewsResponseModel.fromJson(data).articles;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } on TypeError {
      throw ApiException(ErrorMessages.modelMismatch);
    }
  }
}
