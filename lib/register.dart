// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:certificate_verification/models/user_api_response.dart';
import 'package:certificate_verification/style/theme.dart' as Theme;
import 'package:certificate_verification/utils/bubble_indication_painter.dart';
import 'package:certificate_verification/utils/otp_controller.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  late Future<UserApiResponse> futureUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late PageController _pageController;

  final FocusNode myFocusNodePhoneNumberLogin = FocusNode();
  final FocusNode myFocusNodeOTPLogin = FocusNode();

  final FocusNode myFocusNodeFirstName = FocusNode();
  final FocusNode myFocusNodeLastName = FocusNode();
  final FocusNode myFocusNodePhoneNumber = FocusNode();

  TextEditingController _loginPhoneNumberConroller = TextEditingController();
  TextEditingController loginOTPController = TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupFirstNameController = TextEditingController();
  TextEditingController signupLastNameNameController = TextEditingController();
  TextEditingController signupPhoneNumberController = TextEditingController();

  Color left = Colors.black;
  Color right = Colors.white;

  String digitalCodeDigits = "+254";

  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String _inputPhoneNumber = "";

  void addUser() async {
    var params = {
      "firstName": _firstName,
      "lastName": _lastName,
      "phoneNumber": _phoneNumber
    };

    final response = await Dio().post(
      "https://mysterious-spire-67088.herokuapp.com/api/users/adduser",
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(params),
    );

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  Future<UserApiResponse> fetchUser() async {
    final response = await Dio().get(
        "https://mysterious-spire-67088.herokuapp.com/api/users/find?phoneNumber=0$_inputPhoneNumber",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }));
    return UserApiResponse.fromJson(jsonDecode(response.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientStart,
                        Theme.Colors.loginGradientEnd
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 75.0),
                      child: Image(
                          width: 250.0,
                          height: 191.0,
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/RSAK.png')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: _buildMenuBar(context),
                    ),
                    Expanded(
                        flex: 2,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (i) {
                            if (i == 0) {
                              setState(() {
                                right = Colors.black;
                                left = Colors.black;
                              });
                            }
                          },
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: _buildSignIn(context),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: _buildSignUp(context),
                            )
                          ],
                        ))
                  ],
                )),
          ),
        ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Registered",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            Expanded(
                child: TextButton(
              onPressed: _onSignUpButtonPress,
              child: Text(
                "New",
                style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold"),
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 240.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 400,
                        height: 60,
                        child: CountryCodePicker(
                          onChanged: (country) {
                            setState(() {
                              digitalCodeDigits = country.dialCode!;
                            });
                          },
                          initialSelection: "KE",
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          favorite: ["+254", "KE"],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 25, left: 25),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          maxLength: 9,
                          onChanged: (n) => setState(() {
                            _inputPhoneNumber = n;
                          }),
                          controller: _loginPhoneNumberConroller,
                          decoration: InputDecoration(
                            icon: Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.green,
                              size: 22.0,
                            ),
                            hintText: "XXX XXX XXX",
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(digitalCodeDigits),
                            ),
                          ),
                        ),
                      ),
                      /* Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePhoneNumberLogin,
                          controller: loginPhoneNumberConroller,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.phone,
                                color: Colors.green,
                                size: 22.0,
                              ),
                              hintText: "XXX XXX XXX",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                              prefix: Padding(
                                padding: EdgeInsets.all(4),
                                child: Text("Test"),
                              )),
                        ),
                      ), */
                      /*  Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeOTPLogin,
                          controller: loginOTPController,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.green,
                            ),
                            hintText: "OTP",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ) */
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 160.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  /* boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: const [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp), */
                ),
                child: MaterialButton(
                  onPressed: () async {
                    var regUser = await fetchUser();
                    if (regUser.body != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => OTPController(
                                codeDigits: digitalCodeDigits,
                                phone: _loginPhoneNumberConroller.text,
                              )));
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("WELCOME"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                const Text("Kindly Sign Up first"),
                                Text("Error: ${regUser.message}"),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  color: Colors.green,
                  //highlightColor: Colors.transparent,
                  //splashColor: Theme.Colors.loginGradientEnd,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "SEND OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void showInSnackBarLogin() {
    FocusScope.of(context).requestFocus(new FocusNode());

    const snackBar = SnackBar(
      content: Text(
        "Login button pressed",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 400.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeFirstName,
                          controller: signupFirstNameController,
                          onChanged: (f) => setState(() {
                            _firstName = f;
                          }),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "First Name",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeLastName,
                          controller: signupLastNameNameController,
                          onChanged: (l) => setState(() {
                            _lastName = l;
                          }),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.userAlt,
                              color: Colors.black,
                            ),
                            hintText: "Last Name",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePhoneNumber,
                          controller: signupPhoneNumberController,
                          onChanged: (p) => setState(() {
                            _phoneNumber = p;
                          }),
                          keyboardType: TextInputType.number,
                          maxLength: 9,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.phoneAlt,
                              color: Colors.black,
                            ),
                            hintText: "0 XXX XXX XXX",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: ElevatedButton(
                          onPressed: addUser,
                          child: const Text("SIGN UP"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              minimumSize: Size.fromHeight(50)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
