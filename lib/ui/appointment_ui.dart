import 'dart:io';

import '../domain/services/appointment_service.dart';
import '../domain/services/patient_service.dart';
import '../domain/services/staff_service.dart';
import '../utils/date_utils.dart';


class AppointmentUI {
  final AppointmentService appointmentService;
  final PatientService patientService;
  final StaffService staffService;

  AppointmentUI(this.appointmentService, this.patientService, this.staffService);

  void displayAppointmentMenu() {
    while (true) {
      print('\n--- Appointment Scheduling ---');
      print('1. Book New Appointment');
      print('2. View Doctor Schedule');
      print('3. Cancel Appointment');
      print('4. Reschedule Appointment');
      print('5. Back to Main Menu');
      stdout.write('Enter your choice: ');

      final choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          bookAppointment();
          break;
        case '2':
          viewDoctorSchedule();
          break;
        case '3':
          cancelAppointment();
          break;
        case '4':
          rescheduleAppointment();
          break;
        case '5':
          return;
        default:
          print('Invalid choice.');
      }
    }
  }

  void bookAppointment() {
    print('\n--- Book New Appointment ---');
    stdout.write('Enter Patient ID: ');
    final patientId = stdin.readLineSync()!;
    if (patientService.getPatientById(patientId) == null) {
      print('Error: Patient not found.');
      return;
    }

    stdout.write('Enter Doctor ID: ');
    final doctorId = stdin.readLineSync()!;
    if (staffService.getStaffById(doctorId) == null) {
      print('Error: Doctor not found.');
      return;
    }

    stdout.write('Enter Appointment Date (YYYY-MM-DD HH:MM): ');
    final dateTimeStr = stdin.readLineSync()!;
    final dateTime = DateTime.parse(dateTimeStr);

    try {
      final appointment = appointmentService.bookAppointment(patientId, doctorId, dateTime);
      print('Appointment booked successfully with ID: ${appointment.id}');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
  
  void viewDoctorSchedule() {
    stdout.write('Enter Doctor ID to view schedule: ');
    final doctorId = stdin.readLineSync()!;
    stdout.write('Enter Date (YYYY-MM-DD): ');
    final dateStr = stdin.readLineSync()!;
    final date = DateTime.parse(dateStr);

    final schedule = appointmentService.getDoctorSchedule(doctorId, date);
    if(schedule.isEmpty){
      print('No appointments found for Dr. $doctorId on ${formatDateOnly(date)}');
      return;
    }

    print('\n--- Schedule for Dr. $doctorId on ${formatDateOnly(date)} ---');
    schedule.forEach((appt) {
      print('Time: ${formatTimeOnly(appt.dateTime)}, Patient ID: ${appt.patientId}, Status: ${appt.status}');
    });
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
