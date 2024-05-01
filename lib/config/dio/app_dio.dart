import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../keys/headers.dart';
import 'interceptors.dart';

class AppDio {
  Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
  ));
  final BuildContext context;
  static bool initialize = false;
  final bool customRequest;

  AppDio(this.context, {this.customRequest = false}) {
    init();
  }

  init() {
    _dio = Dio();
    if (!customRequest) {
      _dio.interceptors.add(AppDioInterceptor(context));
    }
    initialize = true;
  }

  Future<Response> get({
    required String path,
    Options? options,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    assert(initialize, "Dio not initialize, call the init() first");
    if (options != null) {
      options.contentType = Application.xFormUrlEncoded;
      options..headers?.addAll({HttpHeaders.acceptHeader: Application.json});
    } else {
      options = Options(
          contentType: Application.xFormUrlEncoded,
          headers: {HttpHeaders.acceptHeader: Application.json});
    }
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  Future<Response> post({
    required String path,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    assert(initialize, "Dio not initialize, call the init() first");
    if (options != null) {
      options.contentType = Application.xFormUrlEncoded;
      options..headers!.addAll({HttpHeaders.acceptHeader: Application.json});
    } else {
      options = Options(
          contentType: Application.xFormUrlEncoded,
          headers: {HttpHeaders.acceptHeader: Application.json});
    }
    return _dio.post(
      path,
      data: data,
      options: options,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  Future<Response> postJson({
    required String path,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    assert(initialize, "Dio not initialize, call the init() first");
    if (options != null) {
      options.contentType = Application.json;
    } else {
      options = Options(contentType: Application.json);
    }
    return _dio.post(
      path,
      data: json.encode(data),
      options: options,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  Future<Response> put({
    required String path,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    assert(initialize, "Dio not initialize, call the init() first");
    if (options != null) {
      options.contentType = Application.xFormUrlEncoded;
      options..headers!.addAll({HttpHeaders.acceptHeader: Application.json});
    } else {
      options = Options(
          contentType: Application.xFormUrlEncoded,
          headers: {HttpHeaders.acceptHeader: Application.json});
    }
    return _dio.put(
      path,
      data: data,
      options: options,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  Future<Response> putJson({
    required String path,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    assert(initialize, "Dio not initialize, call the init() first");
    if (options != null) {
      options.contentType = Application.json;
    } else {
      options = Options(contentType: Application.json);
    }
    return _dio.put(
      path,
      data: json.encode(data),
      options: options,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  Future<Response> patch({
    required String path,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    assert(initialize, "Dio not initialize, call the init() first");
    if (options != null) {
      options.contentType = Application.xFormUrlEncoded;
      options..headers!.addAll({HttpHeaders.acceptHeader: Application.json});
    } else {
      options = Options(
          contentType: Application.xFormUrlEncoded,
          headers: {HttpHeaders.acceptHeader: Application.json});
    }
    return _dio.patch(
      path,
      data: data,
      options: options,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  Future<Response> patchJson({
    required String path,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    assert(initialize, "Dio not initialize, call the init() first");
    if (options != null) {
      options.contentType = Application.json;
    } else {
      options = Options(contentType: Application.json);
    }
    return _dio.patch(
      path,
      data: json.encode(data),
      options: options,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  Future<Response> delete({
    required String path,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    assert(initialize, "Dio not initialize, call the init() first");
    if (options != null) {
      options..headers!.addAll({HttpHeaders.acceptHeader: Application.json});
    } else {
      options = Options(headers: {HttpHeaders.acceptHeader: Application.json});
    }
    return _dio.delete(
      path,
      data: data,
      options: options,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }
}
