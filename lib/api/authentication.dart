import 'dart:convert';
import 'dart:io';
import 'package:certificate_verification/models/api_error.dart';
import 'package:certificate_verification/models/certificate_api_response.dart';
import 'package:certificate_verification/models/user.dart';
import 'package:http/http.dart' as http;

String _baseUrl = "https://localhost:8000";

/* Future<ApiResponse> authenticateUser(
    String firstName, String lastName, int phoneNumber) async {
  ApiResponse _apiResponse = new ApiResponse();

  try {
    final response = await http.post(Uri.parse('${_baseUrl}user/login'), body: {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber
    });

    switch (response.statusCode) {
      case 200:
        _apiResponse.Data = User.fromJson(json.decode(response.body));
        break;
      case 401:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
      default:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
  } on SocketException {
    _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
  }
  return _apiResponse;
} */
