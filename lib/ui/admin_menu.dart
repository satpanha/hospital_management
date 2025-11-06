import 'dart:io';
import 'staff_ui.dart';

class AdminMenu {
  final StaffUI staffUI;

  AdminMenu(this.staffUI);

  void show() {
    while (true) {
      print('\n===== Admin Menu =====');
      print('1. Manage Staff');
      print('2. View All Staff');
      print('3. Logout');
      stdout.write('Enter your choice: ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          staffUI.displayStaffMenu();
          break;
        case '2':
          staffUI.listAllStaff();
          break;
        case '3':
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }
}
