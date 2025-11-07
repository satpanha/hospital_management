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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dob': dob.toIso8601String(),
      'contact': contact,
      'address': address,
      'role': role.toString().split('.').last,
      'specialization': specialization,
      'availability': availability,
      'password': password,
    };
  }

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      dob: DateTime.parse(json['dob']),
      contact: json['contact'],
      address: json['address'],
      role: Role.values.firstWhere(
          (e) => e.toString().split('.').last == json['role'],
          orElse: () => Role.receptionist),
      specialization: json['specialization'] ?? 'None',
      availability: json['availability'] ?? 'Not set',
      password: json['password'],
    );
  }
  
  @override  String toString() {
    return '${super.toString()}, Role: $role, '
        'Specialization: $specialization, Availability: $availability, '
        'Contact: $contact, Address: $address';
  }
}
