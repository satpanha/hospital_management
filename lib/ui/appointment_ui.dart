import 'dart:io';
import 'package:hostpital_management/domain/models/appointment.dart';
import 'package:intl/intl.dart';
import '../domain/models/staff.dart';
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
          _bookAppointmentInteractive();
          pause();
          break;
        case '2':
          clearScreen();
          _viewDoctorScheduleInteractive();
          pause();
          break;
        case '3':
          clearScreen();
          _cancelAppointmentInteractive();
          pause();
          break;
        case '4':
          clearScreen();
          _rescheduleAppointmentInteractive();
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

  void bookAppointment({
    required String patientPhone,
    required String doctorId,
    required DateTime dateTime,
  }) {
    try {
      final appointment = appointmentService.bookAppointment(
        patientPhone,
        doctorId,
        dateTime,
      );
      print('Appointment booked successfully with ID: ${appointment.id}');
    } catch (e) {
      print(' Error: ${e.toString()}');
    }
  }

  void markAppointmentAsCompleted(String appointmentId, String description) {
    try {
      appointmentService.markAppointmentCompleted(appointmentId, description);
      print('Appointment marked as completed with note.');
    } catch (e) {
      print(' Error: ${e.toString()}');
    }
  }

  void viewDoctorSchedule(String doctorId) {
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

  print('\n--- Schedule for Dr. ${doctor.name} - (${formatDateOnly(DateTime.now())}) ---');

  final now = DateTime.now();
  var shown = false;

  for (final appt in schedule) {
    if (appt.status == AppointmentStatus.completed || appt.status == AppointmentStatus.cancelled) continue;

    if (appt.dateTime.isBefore(now) &&
        appt.status == AppointmentStatus.scheduled) {
      appt.status = AppointmentStatus.noShow;
      appointmentService.markAppointmentNoShow(appt.id);
    }

    final patient = patientService.getPatientById(appt.patientId);

    
    print('\nDate: ${formatDateOnly(appt.dateTime)} '
        '(${appt.dateTime.hour.toString().padLeft(2, '0')}:${appt.dateTime.minute.toString().padLeft(2, '0')})');
    print(' Patient: ${patient?.name ?? "Unknown"}');
    print(' Contact: ${patient?.contact ?? "N/A"}');
    print(' Address: ${patient?.address ?? "N/A"}');
    print(' Status: ${appt.status.name}');
    print(' Remaining: ${calculateRemainingTime(appt.dateTime)}');
    print('-----------------------------------------------------');
    shown = true;
  }
  if (!shown) {
    print('\nNo upcoming appointments to display.');
  }
}


  void _bookAppointmentInteractive() {
    print('\n--- Book New Appointment ---');
    stdout.write('Enter Patient Phone Number: ');
    final patientPhone = stdin.readLineSync()?.trim() ?? '';

    final patient = patientService.getPatientByPhoneNumber(patientPhone);
    if (patient == null) {
      print('Patient not found.');
      return;
    }

    final doctors = staffService
        .getAllStaff()
        .where((s) => s.role == Role.doctor)
        .toList();
    if (doctors.isEmpty) {
      print('No doctors available.');
      return;
    }

    print('\n--- Available Doctors ---');
    for (var i = 0; i < doctors.length; i++) {
      print('${i + 1}. ${doctors[i].name} (${doctors[i].availability})');
    }

    stdout.write('Select a doctor by number: ');
    final doctorChoice = int.tryParse(stdin.readLineSync() ?? '');
    if (doctorChoice == null ||
        doctorChoice < 1 ||
        doctorChoice > doctors.length) {
      print('Invalid selection.');
      return;
    }

    final selectedDoctor = doctors[doctorChoice - 1];
    stdout.write('Enter Appointment Date (YYYY-MM-DD): ');
    final date = DateFormat('yyyy-MM-dd').parse(stdin.readLineSync() ?? '');
    stdout.write('Enter Appointment Time (HH:mm): ');
    final time = stdin.readLineSync()?.trim() ?? '00:00';
    final dateTime = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).parseStrict('${DateFormat('yyyy-MM-dd').format(date)} $time');

    bookAppointment(
      patientPhone: patientPhone,
      doctorId: selectedDoctor.id,
      dateTime: dateTime,
    );
  }

  void _viewDoctorScheduleInteractive() {
    stdout.write('Enter Doctor ID: ');
    final id = stdin.readLineSync()?.trim() ?? '';
    viewDoctorSchedule(id);
  }

  void _cancelAppointmentInteractive() {
    stdout.write('Enter Appointment ID: ');
    final id = stdin.readLineSync()?.trim() ?? '';
    appointmentService.cancelAppointment(id);
    print('Appointment cancelled.');
  }

  void _rescheduleAppointmentInteractive() {
    stdout.write('Enter Appointment ID: ');
    final id = stdin.readLineSync()?.trim() ?? '';
    stdout.write('Enter new date (YYYY-MM-DD): ');
    final date = DateFormat('yyyy-MM-dd').parse(stdin.readLineSync() ?? '');
    stdout.write('Enter new time (HH:mm): ');
    final time = stdin.readLineSync()?.trim() ?? '00:00';
    final newDateTime = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).parseStrict('${DateFormat('yyyy-MM-dd').format(date)} $time');
    appointmentService.rescheduleAppointment(id, newDateTime);
    print('Appointment rescheduled.');
  }
}
