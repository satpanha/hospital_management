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
  String toString() {
    return '${super.toString()}, Contact: $contact, Address: $address';
  }

  String get medicalSummary =>
      medicalList.isEmpty ? 'No Medical History' : medicalList.join('\n');
}
