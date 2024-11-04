import 'package:dio/dio.dart';

final apiConfig = BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api/v1/',
    connectTimeout: const Duration(seconds: 1600));
