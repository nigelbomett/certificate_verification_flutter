import 'dart:convert';
import 'dart:ui';

import 'package:certificate_verification/models/certificate.dart';
import 'package:certificate_verification/models/certificate_api_response.dart';
import 'package:certificate_verification/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<CertificateApiResponse> futureCertificate;
  late TextEditingController _vehicleRegistrationController;
  String _vehicleRegistrationInput = "";

  @override
  void initState() {
    _vehicleRegistrationController = new TextEditingController();
    initializeDateFormatting('en_US');
    super.initState();
  }

  /*  @override
  void didChangeDependencies() {
    futureCertificate = fetchCertificate();
    super.didChangeDependencies();
  } */

  @override
  void dispose() {
    _vehicleRegistrationController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('phoneNumber');
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  Future<CertificateApiResponse> fetchCertificate() async {
    /* final response = await http.get(Uri.parse(
        "https://modern-hound-14.loca.lt/api/certificates?vehicleRegistrationNumber=$_vehicleRegistrationInput")); */
    /* try {
      final response = await Dio().get(
          "https://modern-hound-14.loca.lt/api/certificates?vehicleRegistrationNumber=$_vehicleRegistrationInput");
      return CertificateApiResponse.fromJson(jsonDecode(response.data));
    } catch (e) {
      print(e);
    } */
    final response = await Dio().get(
        "https://mysterious-spire-67088.herokuapp.com/api/certificates?vehicleRegistrationNumber=$_vehicleRegistrationInput",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }));

    return CertificateApiResponse.fromJson(jsonDecode(response.toString()));

    /* if (response.statusCode == 200) {
      return CertificateApiResponse.fromJson(jsonDecode(response.data));
    } else {
      //throw Exception('Failed to load certificate');
      return CertificateApiResponse.fromJson(jsonDecode(response.data));
    } */
  }

  getFormattedDateFromFormattedString(
      {required value,
      required String currentFormat,
      required String desiredFormat,
      isUtc = true}) {
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        dateTime = DateFormat(desiredFormat).parse(value, isUtc).toLocal();
      } catch (e) {
        print("$e");
      }
    }
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    //final User args = ModalRoute.of(context)!.settings.arguments;

    return WillPopScope(
        onWillPop: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => LoginRegister()));

          return Future.value(true);
        },
        child: new Scaffold(
            appBar: AppBar(
              title: const Text("CERTIFICATE VERIFICATION"),
            ),
            body:
                //Container(
                /* child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Text("Welcome back " + args.firstName + "!"),
            Text("Welcome back"),
            ElevatedButton(
              onPressed: _handleLogout,
              child: Text('Logout'),
            )
          ],
        ), */
                //height: 50,
                //width: 380,

                /*  decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(5.0),), */
                Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                const SizedBox(height: 50),
                const Image(
                  image: AssetImage('assets/images/verified_512.png'),
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelText: 'Enter Vehicle Registration',
                      alignLabelWithHint: true),
                  controller: _vehicleRegistrationController,
                  onChanged: (t) => setState(() {
                    _vehicleRegistrationInput = t.toUpperCase();
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () async {
                    var data = await fetchCertificate();

                    if (data.body != null) {
                      DateTime formattedCertExpiry =
                          getFormattedDateFromFormattedString(
                              value: data.body!.certificateExpiry,
                              currentFormat: "yyyy-MM-ddTHH:mm:ss.Z",
                              desiredFormat: "yyyy-MM-dd");
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(data.body!.vehicleRegistrationNumber),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    text: 'Certificate Number: ',
                                    style: TextStyle(
                                        fontSize: 17), // default text style
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${data.body!.certificateNumber}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Chassis: ',
                                    style: TextStyle(
                                        fontSize: 17), // default text style
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${data.body!.vehicleChassisNumber}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Status: ',
                                    style: TextStyle(
                                        fontSize: 17), // default text style
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: data.body!.certificateStatus !=
                                                  null
                                              ? data.body!.certificateStatus
                                              : "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: data.body!
                                                          .certificateStatus ==
                                                      "valid"
                                                  ? Colors.green
                                                  : Colors.red)),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Expiry Date: ',
                                    style: TextStyle(
                                        fontSize: 17), // default text style
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              '${DateFormat('dd-MM-yyyy').format(formattedCertExpiry)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                    ],
                                  ),
                                )
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
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(_vehicleRegistrationInput),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                const Text("Certificate Not Found"),
                                Text("Error: ${data.message}"),
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

                  /* FutureBuilder<CertificateApiResponse>(
                future: fetchCertificate(),
                builder: (context, snapshot) {
                  print("Test Test Test Test");
                  print(snapshot);
                  if (snapshot.hasData) {
                    //return Text(snapshot.data!.certificateNumber);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            snapshot.data!.body!.vehicleRegistrationNumber),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                  "Chassis: ${snapshot.data!.body!.vehicleChassisNumber}"),
                              Text(
                                  "Status: ${snapshot.data!.body!.certificateStatus}"),
                              Text(
                                  "Expiry Date: ${snapshot.data!.body!.certificateExpiry}")
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
                  } else if (snapshot.hasError) {
                    //return Text('${snapshot.error}');
                    print(snapshot);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(_vehicleRegistrationInput),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              const Text("Certificate Not Found"),
                              Text("Error: ${snapshot.error}"),
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
                  //By default display spinner
                  return const CircularProgressIndicator();
                },
              ), */
                  child: const Text(
                    'VERIFY CERTIFICATE',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ]),
            )));
  }
}
