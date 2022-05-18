class Certificate {
  late String certificateNumber;
  late String vehicleRegistrationNumber;
  late String vehicleChassisNumber;
  late String? certificateStatus;
  late String certificateExpiry;

  Certificate({
    required this.certificateNumber,
    required this.vehicleRegistrationNumber,
    required this.vehicleChassisNumber,
    required this.certificateStatus,
    required this.certificateExpiry,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      certificateNumber: json['certificateNumber'] as String,
      vehicleRegistrationNumber: json['vehicleRegistrationNumber'] as String,
      vehicleChassisNumber: json['vehicleChassisNumber'] as String,
      //if(certificateStatus != null) certificateStatus : json['certificateStatus'],
      certificateStatus: json['certificateStatus'] as String?,
      certificateExpiry: json['certificateExpiry'] as String,
    );
  }
}
