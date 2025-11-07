import 'dart:convert';
import 'package:test/test.dart';
import 'package:hostpital_management/domain/models/staff.dart';
import 'package:hostpital_management/domain/models/appointment.dart';
import 'package:hostpital_management/domain/models/patient.dart';
import 'package:hostpital_management/domain/models/person.dart';

void main() {
  group('Appointment JSON serialization', () {
    // Setup sample data (like in your initialization logic)
    final patient = Patient(
      id: 'P001',
      name: 'John Doe',
      dob: DateTime(1985, 6, 15),
      contact: '0123456789',
      address: '123 Main Street, Phnom Penh',
    );

    final doctor = Staff(
      id: 'D001',
      name: 'Dr. Dara Vann',
      dob: DateTime(1980, 5, 12),
      contact: '011223344',
      address: 'Phnom Penh, Cambodia',
      role: Role.doctor,
      specialization: 'Cardiology',
      availability: 'Mon-Fri 9am-4pm',
      password: '1234',
    );

    test('should convert Appointment to JSON and back correctly (pass-by-reference)', () {
      // Create appointment
      final appointment = Appointment(
        id: 'AP001',
        patient: patient,
        doctor: doctor,
        dateTime: DateTime(2025, 11, 6, 10, 30),
        status: AppointmentStatus.scheduled,
        notes: 'Initial consultation',
        medical: 'Blood pressure check',
      );

      // Convert to JSON
      final jsonString = jsonEncode(appointment.toJson());
      print('Encoded Appointment JSON:\n$jsonString\n');

      // Decode JSON back to map
      final decodedMap = jsonDecode(jsonString);

      // Recreate appointment by reusing same patient & doctor (pass-by-reference)
      final restored = Appointment.fromJson(decodedMap, patient, doctor);

      // Assertions
      expect(restored.id, equals(appointment.id));
      expect(restored.patient.id, equals(patient.id));
      expect(restored.doctor.id, equals(doctor.id));
      expect(restored.status, equals(AppointmentStatus.scheduled));
      expect(restored.notes, equals('Initial consultation'));
      expect(restored.medical, equals('Blood pressure check'));

      print('Restored Appointment object:\n${restored.toString()}');
    });
  });

  group('Staff JSON serialization', () {
    test('should convert Staff to JSON and back correctly', () {
      final staff = Staff(
        id: 'ST001',
        name: 'Dr. Dara Vann',
        dob: DateTime(1980, 5, 12),
        contact: '012345678',
        address: 'Phnom Penh, Cambodia',
        role: Role.doctor,
        specialization: 'Cardiology',
        availability: 'Mon-Fri 9am-4pm',
        password: '1234',
      );

      final jsonString = jsonEncode(staff.toJson());
      print('Encoded JSON: $jsonString');

      final decoded = jsonDecode(jsonString);
      final restored = Staff.fromJson(decoded);

      expect(restored.id, equals(staff.id));
      expect(restored.name, equals(staff.name));
      expect(restored.role, equals(staff.role));
      expect(restored.specialization, equals(staff.specialization));
      expect(restored.availability, equals(staff.availability));
      expect(restored.password, equals(staff.password));

      print('Restored Staff: ${restored.toString()}');
    });
  });

  group('Person JSON serialization', () {
    test('should convert Person to JSON and back correctly', () {
      final person = Person(
        id: 'PER001',
        name: 'John Doe',
        dob: DateTime(2000, 1, 1),
        contact: '012345678',
        address: 'Phnom Penh',
      );

      final jsonString = jsonEncode(person.toJson());
      print('Encoded JSON: $jsonString');

      final decoded = jsonDecode(jsonString);
      final restored = Person.fromJson(decoded);

      expect(restored.id, equals(person.id));
      expect(restored.name, equals(person.name));
      expect(restored.dob, equals(person.dob));
      expect(restored.contact, equals(person.contact));
      expect(restored.address, equals(person.address));

      print('Restored Person: ${restored.toString()}');
    });
  });

  group('Patient JSON serialization', () {
    test('should convert Patient to JSON and back correctly', () {
      // Create a sample patient
      final patient = Patient(
        id: 'P001',
        name: 'John Doe',
        dob: DateTime(1990, 5, 15),
        contact: '012345678',
        address: 'Phnom Penh',
      )
        ..medicalList = [
          'Flu - 2023',
          'Covid-19 - 2021',
        ];

      // Convert to JSON
      final jsonData = patient.toJson();
      final jsonString = jsonEncode(jsonData);
      print('Encoded JSON:\n$jsonString\n');

      // Decode back from JSON
      final decodedMap = jsonDecode(jsonString);
      final restoredPatient = Patient.fromJson(decodedMap);

      // Assertions
      expect(restoredPatient.id, equals(patient.id));
      expect(restoredPatient.name, equals(patient.name));
      expect(restoredPatient.dob, equals(patient.dob));
      expect(restoredPatient.contact, equals(patient.contact));
      expect(restoredPatient.address, equals(patient.address));
      expect(restoredPatient.medicalList, equals(patient.medicalList));

      print('Restored Patient: ${restoredPatient.toString()}');
      print('Medical Summary:\n${restoredPatient.medicalSummary}');
    });
  });
}



// void main() {
//   group('Staff JSON serialization', () {
//     test('should convert Staff to JSON and back correctly', () {
//       final staff = Staff(
//         id: 'ST001',
//         name: 'Dr. Dara Vann',
//         dob: DateTime(1980, 5, 12),
//         contact: '012345678',
//         address: 'Phnom Penh, Cambodia',
//         role: Role.doctor,
//         specialization: 'Cardiology',
//         availability: 'Mon-Fri 9am-4pm',
//         password: '1234',
//       );

//       final jsonString = jsonEncode(staff.toJson());
//       print('Encoded JSON: $jsonString');

//       final decoded = jsonDecode(jsonString);
//       final restored = Staff.fromJson(decoded);

//       expect(restored.id, equals(staff.id));
//       expect(restored.name, equals(staff.name));
//       expect(restored.role, equals(staff.role));
//       expect(restored.specialization, equals(staff.specialization));
//       expect(restored.availability, equals(staff.availability));
//       expect(restored.password, equals(staff.password));

//       print('Restored Staff: ${restored.toString()}');
//     });
//   });
// }

// import 'dart:convert';
// import 'package:test/test.dart';
// import 'package:hostpital_management/domain/models/person.dart';

// void main() {
//   group('Person JSON serialization', () {
//     test('should convert Person to JSON and back correctly', () {
//       final person = Person(
//         id: 'PER001',
//         name: 'John Doe',
//         dob: DateTime(2000, 1, 1),
//         contact: '012345678',
//         address: 'Phnom Penh',
//       );

//       final jsonString = jsonEncode(person.toJson());
//       print('Encoded JSON: $jsonString');

//       final decoded = jsonDecode(jsonString);
//       final restored = Person.fromJson(decoded);

//       expect(restored.id, equals(person.id));
//       expect(restored.name, equals(person.name));
//       expect(restored.dob, equals(person.dob));
//       expect(restored.contact, equals(person.contact));
//       expect(restored.address, equals(person.address));

//       print('Restored Person: ${restored.toString()}');
//     });
//   });
// }


// import 'dart:convert';
// import 'package:test/test.dart';
// import 'package:hostpital_management/domain/models/patient.dart';

// void main() {
//   group('Patient JSON serialization', () {
//     test('should convert Patient to JSON and back correctly', () {
//       // Create a sample patient
//       final patient = Patient(
//         id: 'P001',
//         name: 'John Doe',
//         dob: DateTime(1990, 5, 15),
//         contact: '012345678',
//         address: 'Phnom Penh',
//       )
//         ..medicalList = [
//           'Flu - 2023',
//           'Covid-19 - 2021',
//         ];

//       // Convert to JSON
//       final jsonData = patient.toJson();
//       final jsonString = jsonEncode(jsonData);
//       print('Encoded JSON:\n$jsonString\n');

//       // Decode back from JSON
//       final decodedMap = jsonDecode(jsonString);
//       final restoredPatient = Patient.fromJson(decodedMap);

//       // Assertions
//       expect(restoredPatient.id, equals(patient.id));
//       expect(restoredPatient.name, equals(patient.name));
//       expect(restoredPatient.dob, equals(patient.dob));
//       expect(restoredPatient.contact, equals(patient.contact));
//       expect(restoredPatient.address, equals(patient.address));
//       expect(restoredPatient.medicalList, equals(patient.medicalList));

//       print('Restored Patient: ${restoredPatient.toString()}');
//       print('Medical Summary:\n${restoredPatient.medicalSummary}');
//     });
//   });
// }
