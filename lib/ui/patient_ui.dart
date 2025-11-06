import 'dart:io';
import 'package:hostpital_management/domain/services/staff_service.dart';

import '../domain/models/patient.dart';
import '../domain/models/appointment.dart';
import '../domain/services/patient_service.dart';
import '../utils/date_utils.dart';
import '../utils/io.dart';
import '../utils/validation.dart';

class PatientUI {
  final PatientService patientService;
  final StaffService staffService;
  PatientUI(this.patientService,this.staffService);

  void displayPatientMenu() {
    while (true) {
      clearScreen();
      print('=== Patient Management ===');
      print('1. Register New Patient');
      print('2. Search/View Patient Details');
      print('3. Update Patient Information');
      print('4. View All Patients');
      print('5. View Patient Appointment History');
      print('6. Back to Main Menu');
      stdout.write('\nEnter your choice: ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          clearScreen();
          registerNewPatient();
          pause();
          break;
        case '2':
          clearScreen();
          searchAndDisplayPatient();
          pause();
          break;
        case '3':
          clearScreen();
          updatePatient();
          pause();
          break;
        case '4':
          clearScreen();
          listAllPatients();
          pause();
          break;
        case '5':
          clearScreen();
          viewAppointmentHistory();
          pause();
          break;
        case '6':
          return;
        default:
          print('Invalid choice. Try again.');
          pause();
      }
    }
  }

  void registerNewPatient() {
    print('\n--- Register New Patient ---');
    final name = readNonEmpty('Enter Name: ');
    final dob = readDate('Enter Date of Birth (YYYY-MM-DD): ');
    final contact = readPhone('Enter Contact Number: ');
    final address = readNonEmpty('Enter Address: ');

    final patient = patientService.registerPatient(
      name,
      dob,
      contact,
      address,
    );
    print('\nPatient registered successfully with ID: ${patient.id}');
  }

  void searchAndDisplayPatient() {
    final query = readNonEmpty('Enter Patient ID, Name, or Phone: ');
    final patients = patientService.searchPatients(query);

    if (patients.isEmpty) {
      print('No patients found.');
      return;
    }

    print('\n--- Search Results ---');
    for (var p in patients) {
      _displayPatientDetails(p);
    }
  }

  void listAllPatients() {
    final patients = patientService.getAllPatients();
    if (patients.isEmpty) {
      print("No patients registered yet.");
      return;
    }

    print('\n--- All Registered Patients ---');
    for (var p in patients) {
      _displayPatientDetails(p);
    }
  }

  void updatePatient() {
    final id = readId('Enter Patient ID to update: ');
    final patient = patientService.getPatientById(id);
    if (patient == null) {
      print('Patient not found.');
      return;
    }

    print('\nEnter new details (leave blank to keep current):');
    stdout.write('Name (${patient.name}): ');
    final name = stdin.readLineSync()!;
    stdout.write('Contact (${patient.contact}): ');
    final contact = stdin.readLineSync()!;
    stdout.write('Address (${patient.address}): ');
    final address = stdin.readLineSync()!;

    final updatedPatient = Patient(
      id: patient.id,
      name: name.isNotEmpty ? name : patient.name,
      dob: patient.dob,
      contact: contact.isNotEmpty ? contact : patient.contact,
      address: address.isNotEmpty ? address : patient.address
    );

    patientService.updatePatient(updatedPatient);
    print('\nPatient information updated successfully.');
  }

  void viewAppointmentHistory() {
    final patientPhone = readPhone('Enter Patient Phone Number: ');
    final patient = patientService.getPatientByPhoneNumber(patientPhone);

    if (patient == null) {
      print('Patient not found.');
      return;
    }

    final history = patientService.getPatientAppointmentHistory(patient.id)
        .where((appt) => appt.status == AppointmentStatus.completed)
        .toList();

    if (history.isEmpty) {
      print('No completed appointments found for ${patient.name}.');
      return;
    }

    print('\n--- Appointment History for ${patient.name} ---');
    for (var appt in history) {
      final doctor = staffService.getStaffById(appt.doctorId);
      print('''
        Appointment ID : ${appt.id}
        Doctor         : ${doctor?.name ?? appt.doctorId}
        Date & Time    : ${formatDate(appt.dateTime)}
        Status         : ${appt.status.name.toUpperCase()}
        Note           : ${appt.notes ?? 'No note recorded'}
        Medical        : ${appt.medical ?? 'None '}
        ''');
    }
  }

  void _displayPatientDetails(Patient p) {
    print('''
      Patient ID     : ${p.id}
      Name           : ${p.name}
      Date of Birth  : ${formatDate(p.dob)}
      Contact        : ${p.contact}
      Address        : ${p.address}
      Medical Summary: ${p.medicalSummary}
    ''');
  }
}
