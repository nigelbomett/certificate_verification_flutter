class User {
  late String _firstName;
  late String _lastName;
  late String _phoneNumber;

  User(String firstName, String lastName, String phoneNumber) {
    this._firstName = firstName;
    this._lastName = lastName;
    this._phoneNumber = phoneNumber;
  }

  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;

  //create the user object from json input
  User.fromJson(Map<String, dynamic> json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _phoneNumber = json['phoneNumber'];
  }

  //exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['phoneNumber'] = this._phoneNumber;
    return data;
  }
}
