import 'package:hostpital_management/domain/models/staff.dart';
import 'package:hostpital_management/domain/services/staff_service.dart';
import 'package:hostpital_management/data/repositories/staff_repository.dart';
import 'package:hostpital_management/data/datasources/in_memory_data_source.dart';
import 'package:test/test.dart';

void main() {
  late StaffService staffService;
  late StaffRepository staffRepository;

  setUp(() {
    final dataSource = InMemoryDataSource();
    staffRepository = StaffRepository(dataSource);
    staffService = StaffService(staffRepository);
  });

  test('should add new staff successfully', () {
    final staff = staffService.addStaff(
      'Dr. House',
      DateTime(1970, 6, 6),
      '9999',
      'Calmet',
      Role.doctor,
      'Takev',
      'secret',
    );

    expect(staffRepository.getById(staff.id)?.name, equals('Dr. House'));
  });

  test('should update staff availability', () {
    final staff = staffService.addStaff(
      'Dr. Lisa',
      DateTime(1985, 7, 7),
      '123',
      'China khmer realtion',
      Role.doctor,
      'Phnom Penh',
      'pw',
    );

    staffService.updateStaffAvailability(staff.id, 'Available');

    final updated = staffRepository.getById(staff.id);
    expect(updated?.availability, 'Available');
  });

  test('should return null if staff not found', () {
    final result = staffRepository.getById('invalid');
    expect(result, isNull);
  });

  test('should search staff by partial name', () {
    final result = staffRepository.search('sok');
    expect(result.any((s) => s.name.contains('Sok')), isTrue);
  });
}
