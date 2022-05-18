import 'package:certificate_verification/models/certificate.dart';

class CertificateApiResponse {
  //_data will hold any response converted into its own object
  late String message;
  //_apiError will hold the error object
  late Certificate? body;

  CertificateApiResponse({required this.message, required this.body});

  factory CertificateApiResponse.fromJson(json) {
    return CertificateApiResponse(
        message: json['message'],
        body: json['body'] != null ? Certificate.fromJson(json['body']) : null);
  }
}
