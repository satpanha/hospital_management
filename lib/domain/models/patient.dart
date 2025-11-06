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

  void validate() {
    if (id.isEmpty) throw ArgumentError('Patient ID cannot be empty');
    if (name.isEmpty) throw ArgumentError('Patient name cannot be empty');
    if (contact.isEmpty) throw ArgumentError('Patient contact cannot be empty');
    if (address.isEmpty) throw ArgumentError('Patient address cannot be empty');
    if (dob.isAfter(DateTime.now())) throw ArgumentError('Date of birth cannot be in the future');
    if (!contact.contains('@') && !RegExp(r'^\d{10,}$').hasMatch(contact)) throw ArgumentError('Invalid contact format');
  }

  @override
  String toString() {
    return '${super.toString()}, Contact: $contact, Address: $address';
  }

  String get medicalSummary =>
      medicalList.isEmpty ? 'No Medical History' : medicalList.join('\n');
}
