import 'package:test/test.dart';
import 'package:hospital_management/data/datasources/in_memory_data_source.dart';
import 'package:hospital_management/domain/services/staff_service.dart';
import 'package:hospital_management/domain/models/staff.dart';

void main() {
  group('StaffService Tests', () {
    late InMemoryDataSource dataSource;
    late StaffService service;

    setUp(() {
      dataSource = InMemoryDataSource();
      service = StaffService(dataSource);
    });

    test('should return all staff', () {
      final staff = service.getAllStaff();
      expect(staff.isNotEmpty, true);
    });

    test('should add new staff', () {
      final staff = Staff(
        id: 'SX01',
        name: 'Test Staff',
        dob: DateTime(1999, 5, 10),
        contact: '011223344',
        address: 'Address',
        role: Role.doctor,
        specialization: 'General',
        availability: 'Mon-Fri',
        password: 'pass',
      );

      service.addStaff(staff);

      final all = service.getAllStaff();
      expect(all.any((s) => s.id == 'SX01'), true);
    });

    test('should update existing staff', () {
      final first = service.getAllStaff().first;

      final updated = Staff(
        id: first.id,
        name: 'Updated Staff',
        dob: first.dob,
        contact: first.contact,
        address: first.address,
        role: first.role,
        specialization: first.specialization,
        availability: first.availability,
        password: first.password,
      );

      service.updateStaff(updated);

      final after = service.getAllStaff().firstWhere((s) => s.id == first.id);
      expect(after.name, 'Updated Staff');
    });
  });
}
