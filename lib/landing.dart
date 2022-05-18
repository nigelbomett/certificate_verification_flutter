import 'package:certificate_verification/api/user_details.dart';
import 'package:certificate_verification/models/api_error.dart';
import 'package:certificate_verification/models/certificate_api_response.dart';
import 'package:certificate_verification/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _phoneNumber = 07;
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _phoneNumber = (prefs.getInt('phoneNumber') ?? 07);
    if (_phoneNumber == 07) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } else {
      /* ApiResponse _apiResponse = await getUserDetails(_phoneNumber);
      if ((_apiResponse.ApiError as ApiError) == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', ModalRoute.withName('/home'),
            arguments: (_apiResponse.Data as User));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', ModalRoute.withName('/login'));
      } */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
