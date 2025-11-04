import 'dart:io';
import 'package:intl/intl.dart';
import '../domain/services/appointment_service.dart';
import '../domain/services/patient_service.dart';
import '../domain/services/staff_service.dart';
import '../utils/date_utils.dart';
import '../utils/io.dart';
import '../utils/validation.dart';

class AppointmentUI {
  final AppointmentService appointmentService;
  final PatientService patientService;
  final StaffService staffService;

  AppointmentUI(this.appointmentService, this.patientService, this.staffService);

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
          print('Invalid choice. Try again.');
          pause();
      }
    }
  }

  void bookAppointment() {
    print('\n--- Book New Appointment ---');
    final patientContact = readPhone('Enter Patient Phone Number: ');
    final patient = patientService.getPatientByPhoneNumber(patientContact);
    if (patient == null) {
      print('Patient not found.');
      return;
    }

    final doctors = staffService
        .getAllStaff()
        .where((s) => s.role.toLowerCase() == 'doctor')
        .toList();

    if (doctors.isEmpty) {
      print('No doctors available.');
      return;
    }

    print('\n--- Available Doctors ---');
    for (var i = 0; i < doctors.length; i++) {
      print('${i + 1}. ${doctors[i].name} (${doctors[i].availability})');
    }

    final doctorChoice = readInt('Select a doctor by number: ', min: 1, max: doctors.length);
    final selectedDoctor = doctors[doctorChoice - 1];
    final date = readDate('Enter Appointment Date (YYYY-MM-DD): ');
    final time = readTime('Enter Appointment Time (HH:MM): ');
    final dateTime = DateFormat('yyyy-MM-dd HH:mm').parseStrict('${DateFormat('yyyy-MM-dd').format(date)} $time');

    try {
      final appointment = appointmentService.bookAppointment(patientContact, selectedDoctor.id, dateTime);
      print('Appointment booked successfully (ID: ${appointment.id})');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void viewDoctorSchedule() {
    final doctorId = readId('Enter Doctor ID to view schedule: ');
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

    print('\n--- Schedule for Dr. ${doctor.name} ---');
    for (final appt in schedule) {
      final patient = patientService.getPatientById(appt.patientId);
      print('${formatDateOnly(appt.dateTime)} ${formatTimeOnly(appt.dateTime)} - ${patient?.name ?? "Unknown"} (${appt.status})');
    }
  }

  void cancelAppointment() {
    final id = readId('Enter Appointment ID to cancel: ');
    try {
      appointmentService.cancelAppointment(id);
      print('Appointment cancelled successfully.');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void rescheduleAppointment() {
    final id = readId('Enter Appointment ID to reschedule: ');
    final date = readDate('Enter New Date (YYYY-MM-DD): ');
    final time = readTime('Enter New Time (HH:MM): ');
    final newDateTime = DateFormat('yyyy-MM-dd HH:mm').parseStrict('${DateFormat('yyyy-MM-dd').format(date)} $time');

    try {
      appointmentService.rescheduleAppointment(id, newDateTime);
      print('Appointment rescheduled successfully.');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
}
