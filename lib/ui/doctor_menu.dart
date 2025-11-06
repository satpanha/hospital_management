import 'dart:io';
import 'package:hostpital_management/domain/models/appointment.dart';
import 'package:hostpital_management/ui/patient_ui.dart';
import 'package:hostpital_management/utils/date_utils.dart';
import 'package:hostpital_management/utils/validation.dart';

import '../../domain/models/staff.dart';
import '../../domain/services/appointment_service.dart';
import '../../domain/services/patient_service.dart';
import './appointment_ui.dart';

class DoctorMenu {
  final AppointmentService appointmentService;
  final PatientService patientService;
  final AppointmentUI appointmentUI;
  final PatientUI patientUI;

  DoctorMenu(
    this.appointmentService,
    this.patientService,
    this.appointmentUI,
    this.patientUI,
  );

  void show({required Staff doctor}) {
    while (true) {
      print('\n===== Doctor Menu =====');
      print('1. View My Schedule');
      print('2. Mark Appointment as Completed');
      print('3. View Appointment History');
      print('4. View Patient History');
      print('5. Logout');
      stdout.write('Enter your choice: ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          appointmentUI.viewDoctorSchedule(doctor.id);
          break;
        case '2':
          _markAsCompleted(doctor);
          break;
        case '3':
          _viewHistory(doctor);
          break;
        case '4':
          patientUI.viewAppointmentHistory();
          break;
        case '5':
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }

  void _markAsCompleted(Staff doctor) {
    final appointments = appointmentService
        .getDoctorSchedule(doctor.id)
        .where((appt) => appt.status == AppointmentStatus.scheduled)
        .toList();
    if (appointments.isEmpty) {
      print('\nNo scheduled appointments to mark as completed.');
      return;
    }

    print('\n--- Scheduled Appointments ---');
    for (var i = 0; i < appointments.length; i++) {
      final appt = appointments[i];
      final patient = appointmentUI.patientService.getPatientById(
        appt.patientId,
      );
      print(
        '${i + 1}. Appointment ID: ${appt.id} | Patient: ${patient?.name ?? appt.patientId} | Date: ${formatDate(appt.dateTime)}',
      );
    }

    stdout.write('\nSelect an appointment number to mark as completed: ');
    final input = stdin.readLineSync();
    final index = int.tryParse(input ?? '') ?? -1;

    if (index < 1 || index > appointments.length) {
      print('Invalid selection.');
      return;
    }

    final selectedAppointment = appointments[index - 1];
    final desc = readNonEmpty(
      'Enter a short description/summary for this appointment: ',
    );

    String medical = readNonEmpty('Enter a medical for patient : ');
    medical += ' at ${selectedAppointment.id} By ${doctor.name}';

    patientService
        .getPatientById(selectedAppointment.patientId)!
        .medicalList
        .add(medical);

    appointmentUI.markAppointmentAsCompleted(selectedAppointment.id, desc);

    print('\nAppointment ${selectedAppointment.id} marked as completed.');
  }

  void _viewHistory(Staff doctor) {
    final appointments = appointmentService.getDoctorSchedule(doctor.id);
    print('\n--- Appointment History ---');
    for (final appt in appointments.where(
      (a) => a.status == AppointmentStatus.completed,
    )) {
      final patient = patientService.getPatientById(appt.patientId);
      print(
        '${patient?.name ?? "Unknown"} on ${appt.dateTime} | Note: ${appt.notes ?? "No notes"}',
      );
    }
  }
}
