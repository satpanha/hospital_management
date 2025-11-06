import 'dart:io';
import '../../domain/models/staff.dart';
import '../../domain/services/patient_service.dart';
import '../../domain/services/staff_service.dart';
import '../../domain/services/appointment_service.dart';
import 'appointment_ui.dart';
import 'patient_ui.dart';
import 'staff_ui.dart';
import 'doctor_menu.dart';
import 'receptionist_menu.dart';
import 'admin_menu.dart';

class MainMenu {
  final PatientService patientService;
  final StaffService staffService;
  final AppointmentService appointmentService;

  late final PatientUI patientUI;
  late final StaffUI staffUI;
  late final AppointmentUI appointmentUI;

  MainMenu({
    required this.patientService,
    required this.staffService,
    required this.appointmentService,
  }) {
    patientUI = PatientUI(patientService,staffService);
    staffUI = StaffUI(staffService);
    appointmentUI = AppointmentUI(appointmentService, patientService, staffService);
  }

  void start() {
    print('\n===== Welcome to Hospital Management System =====');
    while (true) {
      stdout.write('Enter Staff ID: ');
      final id = stdin.readLineSync();
      stdout.write('Enter Password: ');
      final password = stdin.readLineSync();

      final staff = staffService.getStaffById(id!);
      if (staff != null && staff.password == password) {
        print('\nLogin successful! Welcome, ${staff.name} (${staff.role.name.toUpperCase()})');

        switch (staff.role) {
          case Role.doctor:
            DoctorMenu(appointmentService, patientService,appointmentUI,patientUI).show(doctor: staff);
            break;
          case Role.receptionist:
            ReceptionistMenu(patientUI, appointmentUI).show();
            break;
          case Role.admin:
            AdminMenu(staffUI).show();
            break;
        }
      } else {
        print('\nInvalid ID or password. Please try again.\n');
      }
    }
  }
}
