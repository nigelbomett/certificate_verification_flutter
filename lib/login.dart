import 'package:certificate_verification/api/authentication.dart';
import 'package:certificate_verification/models/api_error.dart';
import 'package:flutter/material.dart';
import './models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/certificate_api_response.dart';

class Login extends StatelessWidget {
  final _loginFormKey = GlobalKey<FormState>();
  String _firstName = "";
  String _lastName = "";
  int _phoneNumber = 07;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('_scaffoldKey'),
      body: SafeArea(
          bottom: false,
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _loginFormKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          key: const Key("_username"),
                          decoration: InputDecoration(labelText: "Username"),
                          keyboardType: TextInputType.text,
                          onSaved: (String? value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Password"),
                          obscureText: true,
                          onSaved: (String? value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        ButtonBar(
                          children: <Widget>[
                            /*  ElevatedButton.icon(
                                onPressed: () => _handleSubmitted(context,
                                    _firstName, _lastName, _phoneNumber),
                                icon: Icon(Icons.login),
                                label: Text('Sign in')), */
                          ],
                        )
                      ],
                    )
                  ]),
            ),
          )),
    );
  }

  /*void _handleSubmitted(BuildContext context, String firstName, String lastName,
      int phoneNumber) async {
    final FormState? form = _loginFormKey.currentState;
     ApiResponse _apiResponse = ApiResponse();
    if (!form!.validate()) {
      const SnackBar(
          content: Text('Please fix the errors in red before submitting.'));
    } else {
      form.save();
      _apiResponse = await authenticateUser(firstName, lastName, phoneNumber);
      if ((_apiResponse.ApiError as ApiError) == null) {
        _saveAndRedirectToHome(context);
      } else {
        SnackBar(
            content: Text(
          (_apiResponse.ApiError as ApiError).error,
        ));
      }
    }
  }

  void _saveAndRedirectToHome(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse _apiResponse = ApiResponse();

    await prefs.setString(
        "phoneNumber", ((_apiResponse.Data as User).phoneNumber).toString());

    Navigator.pushNamedAndRemoveUntil(
        context, '/home', ModalRoute.withName('/home'),
        arguments: (_apiResponse.Data as User));
  } */
}
