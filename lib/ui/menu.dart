import 'dart:io';

import '../domain/services/appointment_service.dart';
import '../domain/services/patient_service.dart';
import '../domain/services/staff_service.dart';
import 'appointment_ui.dart';
import 'patient_ui.dart';
import 'staff_ui.dart';

class Menu {
  final PatientService patientService;
  final StaffService staffService;
  final AppointmentService appointmentService;
  
  late final PatientUI patientUI;
  late final StaffUI staffUI;
  late final AppointmentUI appointmentUI;

  Menu({
    required this.patientService,
    required this.staffService,
    required this.appointmentService,
  }) {
    patientUI = PatientUI(patientService);
    staffUI = StaffUI(staffService);
    appointmentUI = AppointmentUI(appointmentService, patientService, staffService);
  }

  void displayMainMenu() {
    while (true) {
      print('\n===== Hospital Management System =====');
      print('1. Manage Patients');
      print('2. Manage Appointments');
      print('3. Manage Staff');
      print('4. Exit');
      stdout.write('Enter your choice: ');

      final choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          patientUI.displayPatientMenu();
          break;
        case '2':
          appointmentUI.displayAppointmentMenu();
          break;
        case '3':
          staffUI.displayStaffMenu();
          break;
        case '4':
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }
}




























