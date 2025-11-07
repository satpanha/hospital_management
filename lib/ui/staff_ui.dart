import 'dart:io';
import '../domain/models/staff.dart';
import '../domain/services/staff_service.dart';
import '../utils/io.dart';
import '../utils/validation.dart';

class StaffUI {
  final StaffService staffService;
  StaffUI(this.staffService);

  void displayStaffMenu() {
    while (true) {
      clearScreen();
      print('=== Staff Management ===');
      print('1. Add New Staff Member');
      print('2. Search/View Staff');
      print('3. Update Staff Details');
      print('4. View All Staff');
      print('5. Back to Main Menu');

      final choice = readNonEmpty('\nEnter your choice: ');

      switch (choice) {
        case '1':
          clearScreen();
          addStaff();
          pause();
          break;
        case '2':
          clearScreen();
          searchStaff();
          pause();
          break;
        case '3':
          clearScreen();
          updateStaff();
          pause();
          break;
        case '4':
          clearScreen();
          listAllStaff();
          pause();
          break;
        case '5':
          return;
        default:
          print('\nInvalid choice. Please try again.');
          pause();
      }
    }
  }

  void addStaff() {
    clearScreen();
    print('\n--- Add New Staff ---');

    final name = readNonEmpty('Enter Name: ');
    final dob = readDate('Enter Date of Birth (yyyy-MM-dd): ');
    final contact = readNonEmpty('Enter Contact Number: ');
    final address = readNonEmpty('Enter Address: ');

    print('\nSelect Role:');
    for (var i = 0; i < Role.values.length; i++) {
      print('${i + 1}. ${Role.values[i].name}');
    }

    Role? selectedRole;
    while (selectedRole == null) {
      final choice = readInt('Enter your choice (1-${Role.values.length}): ',
          min: 1, max: Role.values.length);
      selectedRole = Role.values[choice - 1];
    }

    final specialization = readNonEmpty('Enter Specialization: ');
    final password = readNonEmpty('Enter Password: ');

    final staff = staffService.addStaff(
      name,
      dob,
      contact,
      address,
      selectedRole,
      specialization,
      password,
    );

    print(
        '\nStaff member added successfully with ID: ${staff.id} and Role: ${selectedRole.name}');

    if (selectedRole == Role.doctor) {
      final availability =
          readNonEmpty('Set availability (e.g., Mon-Fri 09:00-17:00): ');
      staffService.updateStaffAvailability(staff.id, availability);
      print('Doctor availability set.');
    }
  }

  void searchStaff() {
    clearScreen();
    final query = readNonEmpty('Enter Staff ID, Name, or Department to search: ');
    final staffList = staffService.searchStaff(query);

    if (staffList.isEmpty) {
      print('No staff found.');
      return;
    }

    print('\n--- Search Results ---');
    for (var s in staffList) {
      print(s);
    }
  }

  void listAllStaff() {
    clearScreen();
    final staffList = staffService.getAllStaff();
    if (staffList.isEmpty) {
      print("No staff registered yet.");
      return;
    }
    print('\n--- All Staff ---');
    for (var s in staffList) {
      print(s);
    }
  }

  void updateStaff() {
    clearScreen();
    final id = readId('Enter Staff ID to update: ');
    final staff = staffService.getStaffById(id);

    if (staff == null) {
      print('Staff not found.');
      return;
    }

    print('Enter new details (leave blank to keep current value):');
    stdout.write('Availability (${staff.availability}): ');
    final availability = stdin.readLineSync()?.trim() ?? '';

    final updatedStaff = Staff(
      id: staff.id,
      name: staff.name,
      dob: staff.dob,
      contact: staff.contact,
      address: staff.address,
      role: staff.role,
      password: staff.password,
      specialization: staff.specialization,
      availability:
          availability.isNotEmpty ? availability : staff.availability,
    );

    staffService.updateStaff(updatedStaff);
    print('Staff details updated successfully.');
  }
}
