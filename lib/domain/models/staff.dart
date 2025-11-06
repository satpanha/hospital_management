import 'package:hostpital_management/domain/models/person.dart';

enum Role { receptionist, doctor, admin }

class Staff extends Person {
  Role role;
  String specialization;
  String availability;
  String password;

  Staff({
    required super.id,
    required super.name,
    required super.dob,
    required super.contact,
    required super.address,
    required this.role,
    this.specialization = 'None',
    this.availability = 'Not set',
    required this.password,
  });

  @override
  String toString() {
    return '${super.toString()}, Role: $role, '
        'Specialization: $specialization, Availability: $availability, '
        'Contact: $contact, Address: $address';
  }
}
