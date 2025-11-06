import 'dart:io';
import 'patient_ui.dart';
import 'appointment_ui.dart';

class ReceptionistMenu {
  final PatientUI patientUI;
  final AppointmentUI appointmentUI;

  ReceptionistMenu(this.patientUI, this.appointmentUI);

  void show() {
    while (true) {
      print('\n===== Receptionist Menu =====');
      print('1. Register New Patient');
      print('2. Manage Patients');
      print('3. Book or Cancel Appointment');
      print('4. Logout');
      stdout.write('Enter your choice: ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          patientUI.registerNewPatient();
          break;
        case '2':
          patientUI.displayPatientMenu();
          break;
        case '3':
          appointmentUI.displayAppointmentMenu();
          break;
        case '4':
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }
}
