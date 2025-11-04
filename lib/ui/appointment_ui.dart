import 'dart:io';
import 'package:intl/intl.dart';

import '../domain/services/appointment_service.dart';
import '../domain/services/patient_service.dart';
import '../domain/services/staff_service.dart';
import '../utils/date_utils.dart';
import '../utils/io.dart';

class AppointmentUI {
  final AppointmentService appointmentService;
  final PatientService patientService;
  final StaffService staffService;

  AppointmentUI(
    this.appointmentService,
    this.patientService,
    this.staffService,
  );

  void displayAppointmentMenu() {
    while (true) {
      clearScreen();
      print('=== Appointment Scheduling ===');
      print('1. Book New Appointment');
      print('2. View Doctor Schedule');
      print('3. Cancel Appointment');
      print('4. Reschedule Appointment');
      print('5. Back to Main Menu');
      stdout.write('\nEnter your choice: ');

      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          clearScreen();
          bookAppointment();
          pause();
          break;
        case '2':
          clearScreen();
          viewDoctorSchedule();
          pause();
          break;
        case '3':
          clearScreen();
          cancelAppointment();
          pause();
          break;
        case '4':
          clearScreen();
          rescheduleAppointment();
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

  void bookAppointment() {
    print('\n--- Book New Appointment ---');
    stdout.write('Enter Patient Phone Number: ');
    final patientContact = stdin.readLineSync()!;
    final patient = patientService.getPatientByPhoneNumber(patientContact);
    if (patient == null) {
      print('Error: Patient not found.');
      return;
    } else {
      print(patient);
    }

    final doctors = staffService
        .getAllStaff()
        .where((staff) => staff.role.toLowerCase() == 'doctor')
        .toList();

    if (doctors.isEmpty) {
      print('No doctors available.');
      return;
    }

    print('\n--- Available Doctors ---');
    for (var i = 0; i < doctors.length; i++) {
      print(
        '${i + 1}. ${doctors[i].name} - (${doctors[i].availability})',
      );
    }

    stdout.write('Select a doctor by number: ');
    final doctorChoice = stdin.readLineSync();

    if (doctorChoice == null || int.tryParse(doctorChoice) == null) {
      print('Invalid selection.');
      return;
    }

    final selectedIndex = int.parse(doctorChoice) - 1;

    if (selectedIndex < 0 || selectedIndex >= doctors.length) {
      print('Invalid selection.');
      return;
    }

    final selectedDoctor = doctors[selectedIndex];
    final doctorId = selectedDoctor.id;

    print(
      'You selected Dr. ${selectedDoctor.name}.',
    );

    stdout.write('Enter Appointment Date (YYYY-MM-DD): ');
    final dateInput = stdin.readLineSync()?.trim();
    if (dateInput == null || dateInput.isEmpty) {
      print('Invalid date input.');
      return;
    }

    stdout.write('Enter Appointment Time (HH:MM): ');
    final timeInput = stdin.readLineSync()?.trim();
    if (timeInput == null || timeInput.isEmpty) {
      print('Invalid time input.');
      return;
    }

    DateTime? dateTime;
    try {
      final combined = '$dateInput $timeInput';
      dateTime = DateFormat('yyyy-MM-dd HH:mm').parseStrict(combined);
    } catch (e) {
      print('Invalid date or time format. Please use YYYY-MM-DD and HH:MM.');
      return;
    }

    try {
      final appointment = appointmentService.bookAppointment(
        patientContact,
        doctorId,
        dateTime,
      );
      print('Appointment booked successfully with ID: ${appointment.id}');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void viewDoctorSchedule() {
    stdout.write('Enter Doctor ID to view schedule: ');
    final doctorId = stdin.readLineSync()!;

    final doctor = staffService.getStaffById(doctorId);
    if (doctor == null) {
      print('Doctor not found.');
      return;
    }

    final schedule = appointmentService.getDoctorSchedule(doctorId);

    if (schedule.isEmpty) {
      print('No appointments found for Dr. ${doctor.name}.');
      return;
    }

    print('\n--- All Appointments for Dr. ${doctor.name} ---');
    print('Today : ${DateTime.now()}');
    for (final appt in schedule) {
      final patient = patientService.getPatientById(appt.patientId);
      final remaining = calculateRemainingTime(appt.dateTime);

      print(
        '\n Date: ${formatDateOnly(appt.dateTime)}'
        '\n Time: ${formatTimeOnly(appt.dateTime)}'
        '\n Patient: ${patient?.name ?? "Unknown"}'
        '\n Contact: ${patient?.contact ?? "N/A"}'
        '\n Remaining: $remaining '
        '\n ---------------------------------------------------------',
      );
    }
  }

  void cancelAppointment() {
    stdout.write('Enter Appointment ID to cancel: ');
    final appointmentId = stdin.readLineSync()!;
    try {
      appointmentService.cancelAppointment(appointmentId);
      print('Appointment cancelled successfully.');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void rescheduleAppointment() {
    stdout.write('Enter Appointment ID to reschedule: ');
    final appointmentId = stdin.readLineSync()!;

    stdout.write('Enter new date and time (YYYY-MM-DD HH:MM): ');
    final newDateTimeStr = stdin.readLineSync()!;
    final newDateTime = DateTime.parse(newDateTimeStr);

    try {
      appointmentService.rescheduleAppointment(appointmentId, newDateTime);
      print('Appointment rescheduled successfully.');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
}
