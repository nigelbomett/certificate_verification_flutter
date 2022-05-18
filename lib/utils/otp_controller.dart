import 'package:certificate_verification/homepage.dart';
import 'package:certificate_verification/utils/bubble_indication_painter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:certificate_verification/style/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pinput.dart';

class OTPController extends StatefulWidget {
  final String phone;
  final String codeDigits;

  OTPController({required this.phone, required this.codeDigits});

  @override
  _OTPControllerState createState() => _OTPControllerState();
}

class _OTPControllerState extends State<OTPController> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  //late PageController _pageController;

  final FocusNode myFocusNodePhoneNumberLogin = FocusNode();
  final FocusNode myFocusNodeOTPLogin = FocusNode();

  final FocusNode myFocusNodeFirstName = FocusNode();
  final FocusNode myFocusNodeLastName = FocusNode();
  final FocusNode myFocusNodePhoneNumber = FocusNode();

  TextEditingController loginPhoneNumberConroller = TextEditingController();
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

  String? verificationCode;
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
      color: Colors.greenAccent,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all());

  @override
  void initState() {
    super.initState();

    verifyPhoneNumber();
  }

  //@override
  /* Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
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
                  child: Image(image: AssetImage('assets/images/RSAK.png')),
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
                          child: _buildOtpPage(context),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignUp(context),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  } */

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/RSAK.png",
            height: 200,
            width: 300,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: GestureDetector(
              onTap: () {
                verifyPhoneNumber();
              },
              child: Text(
                "Verifying : ${widget.codeDigits}${widget.phone}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(40.0),
            child: Pinput(
              length: 6,
              //textStyle: TextStyle(fontSize: 25.0),
              //eachFieldWidth: 30.0,
              //eachFieldHeight: 50.0,
              focusNode: _pinOTPCodeFocus,
              controller: _pinOTPCodeController,
              //submittedFieldDecoration: pinOTPCodeDecoration,
              //selectedFieldDecoration: pinOTPCodeDecoration,
              //: pinOTPCodeDecoration,
              pinAnimationType: PinAnimationType.slide,
              onSubmitted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: verificationCode!, smsCode: pin))
                      .then((value) {
                    if (value.user != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) =>
                              HomePage(title: "Certificate Verification")));
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Invalid OTP"),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
            ))
      ]),
    );
  }

  /*Widget _buildMenuBar(BuildContext context) {
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
                  "Existing",
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

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  Widget _buildOtpPage(BuildContext context) {
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
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        verifyPhoneNumber();
                      },
                      child: Text(
                        "verifying : ${widget.codeDigits}${widget.phone}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  /* child: Column(
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
                    ],
                  ), */
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: Pinput(
                  length: 6,
                  //textStyle: TextStyle(fontSize: 25.0),
                  //eachFieldWidth: 30.0,
                  //eachFieldHeight: 50.0,
                  focusNode: _pinOTPCodeFocus,
                  controller: _pinOTPCodeController,
                  //submittedFieldDecoration: pinOTPCodeDecoration,
                  //selectedFieldDecoration: pinOTPCodeDecoration,
                  //: pinOTPCodeDecoration,
                  pinAnimationType: PinAnimationType.slide,
                  onSubmitted: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationCode!, smsCode: pin))
                          .then((value) {
                        if (value.user != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => HomePage(title: 'HOME')));
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Invalid OTP"),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                ),
              )
              /* Container(
                margin: EdgeInsets.only(top: 160.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: const <BoxShadow>[
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
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  onPressed: () => showInSnackBarLogin(),
                  highlightColor: Colors.transparent,
                  splashColor: Theme.Colors.loginGradientEnd,
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
              ) */
            ],
          )
        ],
      ),
    );
  }
*/
  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.codeDigits}${widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          if (value.user != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (c) => HomePage(
                      title: 'HOME',
                    )));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID, int? resendToken) {
        setState(() {
          verificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID) {
        setState(() {
          verificationCode = vID;
        });
      },
      timeout: Duration(seconds: 60),
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
                  height: 300.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeFirstName,
                          controller: signupFirstNameController,
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
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePhoneNumber,
                          controller: signupPhoneNumberController,
                          keyboardType: TextInputType.phone,
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
                            hintText: "+254 XXX XXX XXX",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
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
}
