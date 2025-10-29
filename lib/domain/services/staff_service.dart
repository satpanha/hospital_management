import '../../data/repositories/staff_repository.dart';
import '../../utils/id_generator.dart';
import '../models/staff.dart';

class StaffService {
  final StaffRepository staffRepository;

  StaffService(this.staffRepository);

  Staff addStaff(String name, String role, String department) {
    final newStaff = Staff(
      id: IdGenerator.generate(),
      name: name,
      role: role,
      department: department,
    );
    staffRepository.add(newStaff);
    return newStaff;
  }

  Staff? getStaffById(String id) {
    return staffRepository.getById(id);
  }
  
  List<Staff> getAllStaff() {
    return staffRepository.getAll();
  }

  List<Staff> searchStaff(String query) {
    return staffRepository.search(query);
  }

  void updateStaff(Staff staff) {
    staffRepository.update(staff);
  }
  
  void updateStaffAvailability(String staffId, String availability) {
    final staff = getStaffById(staffId);
    if(staff != null) {
      staff.availability = availability;
      updateStaff(staff);
    }
  }
}