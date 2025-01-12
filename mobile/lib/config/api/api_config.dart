import 'package:dio/dio.dart';

final apiConfig = BaseOptions(
    baseUrl: 'http://192.168.100.43:8000/api/v1/',
    connectTimeout: const Duration(seconds: 1600));
