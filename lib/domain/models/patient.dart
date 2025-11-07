import 'package:hostpital_management/domain/models/person.dart';

class Patient extends Person {
  List<String> medicalList = [];

  Patient({
    required super.id,
    required super.name,
    required super.dob,
    required super.contact,
    required super.address,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dob': dob.toIso8601String(),
      'contact': contact,
      'address': address,
      'medicalList': medicalList,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      dob: DateTime.parse(json['dob']),
      contact: json['contact'],
      address: json['address'],
    )..medicalList = List<String>.from(json['medicalList'] ?? []);
  }

  @override
  String toString() {
    return '${super.toString()}, Contact: $contact, Address: $address';
  }

  String get medicalSummary =>
      medicalList.isEmpty ? 'No Medical History' : medicalList.join('\n');
}
