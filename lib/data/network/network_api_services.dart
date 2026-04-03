import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';

import '../../Utils/widgets/others/delete_notification_dialog.dart';
import '../../config/keys/pref_keys.dart';
import '../../main.dart';
import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiService implements BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    String? token = pref.getString(PrefKey.authorization);

    var headers = {
      "Content-Type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 20));
      responseJson = returnResponse(response);
      print("$url ======> $responseJson");
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }

    dynamic responseJson;
    String? token = pref.getString(PrefKey.authorization);

    var headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer $token"
    };

    try {
      Response response =
          await post(Uri.parse(url), body: json.encode(data), headers: headers)
              .timeout(const Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String url, dynamic data) async {
    if (kDebugMode) {
      print(url);
      if (data != null) {
        print(data);
      }
    }

    dynamic responseJson;
    String? token = pref.getString(PrefKey.authorization);

    var headers = {
      "Content-Type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer $token"
    };

    try {
      Response response = await delete(
        Uri.parse(url),
        body: data != null ? json.encode(data) : null,
        headers: headers,
      ).timeout(const Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }


  @override
  Future<dynamic> postMultiFileApiRequest(
      String url, Map<String, dynamic> fields, List<String> filePaths,
      {String? videoPath}) async {
    // Debug Mode Logs
    if (kDebugMode) {
      print("Request URL: $url");
      print("Request Fields: $fields");
      print("File Paths: $filePaths");
    }

    // Define the response and authorization token
    dynamic responseJson;
    String? token = pref.getString(PrefKey.authorization);

    // HTTP headers
    var headers = {
      "Authorization": "Bearer $token", // Add Authorization if required
    };

    try {
      // Create a Multipart Request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add fields (handling dynamic values)
      fields.forEach((key, value) {
        if (value is List) {
          // For lists, convert each item to a string
          for (var item in value) {
            request.fields[key] = item.toString();
          }
        } else {
          // Convert other values to strings
          request.fields[key] = value.toString();
        }
      });

      // Add files (file data)
      for (String filePath in filePaths) {
        if (File(filePath).existsSync()) {
          request.files
              .add(await http.MultipartFile.fromPath('image[]', filePath));
        } else {
          throw Exception("File does not exist: $filePath");
        }
      }

      if (videoPath != null) {
        if (File(videoPath).existsSync()) {
          request.files
              .add(await http.MultipartFile.fromPath('video', videoPath));
        } else {
          throw Exception("File does not exist: $videoPath");
        }
      }

      // Add headers to request
      request.headers.addAll(headers);

      // Send request
      var response = await request.send().timeout(const Duration(seconds: 20));

      // Read and parse response
      if (response.statusCode == 200) {
        responseJson = jsonDecode(await response.stream.bytesToString());
      } else {
        throw FetchDataException(
            'Server Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } on SocketException {
      // Handle no internet error
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      // Handle timeout error
      throw FetchDataException('Network Request Timeout');
    } catch (e) {
      // Catch other exceptions
      throw FetchDataException('Unexpected Error: $e');
    }

    // Debug Mode Logs
    if (kDebugMode) {
      print("Response: $responseJson");
    }

    return responseJson;
  }

  @override
  Future<dynamic> postSingleFileApiRequest(
      String url, Map<String, dynamic> fields, String filePath, {String fileKey = "img" }) async {
    // Debug Mode Logs
    if (kDebugMode) {
      print("Request URL: $url");
      print("Request Fields: $fields");
      print("File Path: $filePath");
    }

    // Define the response and authorization token
    dynamic responseJson;
    String? token = pref.getString(PrefKey.authorization);

    // HTTP headers
    var headers = {
      "Authorization": "Bearer $token", // Add Authorization if required
    };

    try {
      // Create a Multipart Request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add fields
      fields.forEach((key, value) {
        if (value is List) {
          for (var item in value) {
            request.fields['$key[]'] = item.toString();
          }
        } else {
          request.fields[key] = value.toString();
        }
      });

      // Add file
      if (File(filePath).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(fileKey, filePath));
      } else {
        throw Exception("File does not exist: $filePath");
      }

      // Add headers
      request.headers.addAll(headers);

      // Send request with a timeout
      var response = await request.send().timeout(const Duration(seconds: 20));

      // Parse response
      if (response.statusCode == 200) {
        responseJson = jsonDecode(await response.stream.bytesToString());
      } else {
        throw FetchDataException(
            'Server Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request Timeout');
    } catch (e) {
      throw FetchDataException('Unexpected Error: ${e.toString()}');
    }

    // Debug Mode Logs
    if (kDebugMode) {
      print("Response: $responseJson");
    }

    return responseJson;
  }

  bool isNavigating = false; // Define this outside the function to persist its state.

  dynamic returnResponse(http.Response response) {
    if (kDebugMode) {
      print(response.statusCode);
      print(response.body);
    }

    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(jsonDecode(response.body)['error']?.toString() ?? jsonDecode(response.body)['errors']?.toString() ?? jsonDecode(response.body)['message'].toString());
      case 401:
        if(unAuthorized == false){
          unAuthorized = true;
          sessionExpiredDialog(navigatorKey.currentContext!);
        }
        throw UnauthorisedException(jsonDecode(response.body)['errors']!= null ? extractErrorMessage(jsonDecode(response.body)['errors'])  :
          jsonDecode(response.body)['message'].toString());
      case 403:
        throw DataNotFoundException(jsonDecode(response.body)['errors']?.toString() ?? jsonDecode(response.body)['message'].toString());
      case 404:
        throw DataNotFoundException(jsonDecode(response.body)['errors']?.toString() ?? jsonDecode(response.body)['message'].toString());
      case 422:
        throw UnProcessableEntity(
            jsonDecode(response.body)['errors']!= null ? extractErrorMessage(jsonDecode(response.body)['errors'])  :
                jsonDecode(response.body)['message'].toString());
      case 500:
        throw InternalServerException(jsonDecode(response.body)?['message'].toString());
      default:
        throw FetchDataException(
            'Error occurred while communicating with server');
    }
  }
}

String extractErrorMessage(dynamic error) {
  if (error is String) {
    // If the error is a string, return it directly
    return error;
  } else if (error is Map) {
    for (var key in error.keys) {
      var value = error[key];
      if (value is String) {
        // If the value is a string, return it
        return value;
      } else if (value is List && value.isNotEmpty) {
        // If the value is a non-empty list, return the first item
        return value.first.toString();
      }
    }
  }
  // Return a default message if no valid error message is found
  return error.toString();
}


Future<void> sessionExpiredDialog(BuildContext context) async {
  CustomAlertDialog(
    title: "Session Ended",
    description: "Your session has expired. Please log in again to continue.",
    cancelButtonTitle: "",
    removeCancelButton: true,
    barrierDismissible: false,
    confirmButtonTitle: "Log In",
    context: context,
    loading: false,

    onTap: () async {
      Provider.of<UserViewModel>(context, listen: false).logout(context, int.tryParse(pref.getString(PrefKey.userId) ?? ''));
    },
  );
}