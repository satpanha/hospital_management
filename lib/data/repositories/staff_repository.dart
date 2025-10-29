import '../../domain/models/staff.dart';
import '../datasources/in_memory_data_source.dart';

class StaffRepository {
  final InMemoryDataSource dataSource;

  StaffRepository(this.dataSource);

  void add(Staff s) {
    dataSource.addStaff(s);
  }

  Staff? getById(String id) {
    try {
      return dataSource.staff.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Staff> getAll() {
    return dataSource.staff;
  }
  
  List<Staff> search(String query) {
    final lowerCaseQuery = query.toLowerCase();
    return dataSource.staff
        .where((s) =>
            s.id.toLowerCase().contains(lowerCaseQuery) ||
            s.name.toLowerCase().contains(lowerCaseQuery) ||
            s.department.toLowerCase().contains(lowerCaseQuery))
        .toList();
  }

  void update(Staff s) {
    dataSource.updateStaff(s);
  }
}