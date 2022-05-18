import 'user.dart';

class UserApiResponse {
  late String message;
  late User? body;

  UserApiResponse({required this.message, required this.body});

  factory UserApiResponse.fromJson(json) {
    return UserApiResponse(
        message: json['message'],
        body: json['body'] != null ? User.fromJson(json['body']) : null);
  }
}
