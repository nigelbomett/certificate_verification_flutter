import 'dart:io';
import 'dart:convert';
import 'package:certificate_verification/models/api_error.dart';
import 'package:certificate_verification/models/certificate_api_response.dart';
import 'package:certificate_verification/models/user.dart';
import 'package:http/http.dart' as http;

String _baseUrl = "https://localhost:8000";

/* Future<ApiResponse> getUserDetails(int phoneNumber) async {
  ApiResponse _apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse('${_baseUrl}user/$phoneNumber'));

    switch (response.statusCode) {
      case 200:
        _apiResponse.Data = User.fromJson(json.decode(response.body));
        break;
      case 401:
        print((_apiResponse.ApiError as ApiError).error);
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
      default:
        print((_apiResponse.ApiError as ApiError).error);
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
  } on SocketException {
    _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
  }
  return _apiResponse;
}
 */