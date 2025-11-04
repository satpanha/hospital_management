import 'dart:io';

import '../domain/models/staff.dart';
import '../domain/services/staff_service.dart';
import '../utils/io.dart';

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
    stdout.write('\nEnter your choice: ');

    final choice = stdin.readLineSync();

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
    print('\n--- Add New Staff ---');
    stdout.write('Enter Name: ');
    final name = stdin.readLineSync()!;
    stdout.write('Enter Role (e.g., Doctor, Nurse): ');
    final role = stdin.readLineSync()!;
    stdout.write('Enter Department: ');
    final department = stdin.readLineSync()!;

    final staff = staffService.addStaff(name, role, department);
    print('Staff member added successfully with ID: ${staff.id}');
    
    if(role.toLowerCase() == 'doctor') {
      stdout.write('Set availability (e.g., Mon-Fri 09:00-17:00): ');
      final availability = stdin.readLineSync()!;
      staffService.updateStaffAvailability(staff.id, availability);
      print('Doctor availability set.');
    }
  }

  void searchStaff() {
    stdout.write('Enter Staff ID, Name, or Department to search: ');
    final query = stdin.readLineSync()!;
    final staffList = staffService.searchStaff(query);

    if (staffList.isEmpty) {
      print('No staff found.');
      return;
    }
    
    print('\n--- Search Results ---');
    staffList.forEach((s) => print(s));
  }

  void listAllStaff() {
    final staffList = staffService.getAllStaff();
    if (staffList.isEmpty) {
      print("No staff registered yet.");
      return;
    }
    print('\n--- All Staff ---');
    staffList.forEach((s) => print(s));
  }

  void updateStaff() {
    stdout.write('Enter Staff ID to update: ');
    final id = stdin.readLineSync()!;
    final staff = staffService.getStaffById(id);

    if (staff == null) {
      print('Staff not found.');
      return;
    }

    print('Enter new details (leave blank to keep current value):');
    stdout.write('Availability (${staff.availability}): ');
    final availability = stdin.readLineSync()!;

    final updatedStaff = Staff(
      id: staff.id,
      name: staff.name,
      role: staff.role,
      availability: availability.isNotEmpty ? availability : staff.availability,
    );
    
    staffService.updateStaff(updatedStaff);
    print('Staff details updated successfully.');
  }
}