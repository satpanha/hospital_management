import 'package:test/test.dart';
import 'package:hospital_management/data/datasources/in_memory_data_source.dart';
import 'package:hospital_management/domain/models/patient.dart';
import 'package:hospital_management/domain/services/patient_service.dart';

void main() {
  group('PatientService Tests', () {
    late InMemoryDataSource dataSource;
    late PatientService service;

    setUp(() {
      dataSource = InMemoryDataSource();
      service = PatientService(dataSource);
    });

    test('should return all patients', () {
      final patients = service.getAllPatients();
      expect(patients.isNotEmpty, true);
    });

    test('should add a new patient', () {
      final patient = Patient(
        id: 'PX01',
        name: 'Test Patient',
        dob: DateTime(2000, 1, 1),
        contact: '012345678',
        address: 'Test Address',
      );

      service.addPatient(patient);

      final all = service.getAllPatients();
      expect(all.any((p) => p.id == 'PX01'), true);
    });

    test('should update an existing patient', () {
      final first = service.getAllPatients().first;

      final updated = Patient(
        id: first.id,
        name: 'Updated Name',
        dob: first.dob,
        contact: first.contact,
        address: first.address,
      );

      service.updatePatient(updated);

      final after = service.getAllPatients().firstWhere((p) => p.id == first.id);
      expect(after.name, 'Updated Name');
    });
  });
}
