import 'dart:io';
import '../domain/models/patient.dart';
import '../domain/services/patient_service.dart';
import '../utils/date_utils.dart';
import '../utils/io.dart';
import '../utils/validation.dart';

class PatientUI {
  final PatientService patientService;
  PatientUI(this.patientService);

  void displayPatientMenu() {
    while (true) {
      clearScreen();
      print('=== Patient Management ===');
      print('1. Register New Patient');
      print('2. Search/View Patient');
      print('3. Update Patient Details');
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
          searchPatient();
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
    final summary = readNonEmpty('Enter Medical Summary: ');

    final patient = patientService.registerPatient(name, dob, contact, address, summary);
    print('Patient registered successfully with ID: ${patient.id}');
  }

  void searchPatient() {
    final query = readNonEmpty('Enter Patient ID, Name, or Phone to search: ');
    final patients = patientService.searchPatients(query);
    if (patients.isEmpty) {
      print('No patients found.');
      return;
    }
    print('\n--- Search Results ---');
    patients.forEach((p) => print(p));
  }

  void listAllPatients() {
    final patients = patientService.getAllPatients();
    if (patients.isEmpty) {
      print("No patients registered yet.");
      return;
    }
    print('\n--- All Patients ---');
    patients.forEach((p) => print(p));
  }

  void updatePatient() {
    final id = readId('Enter Patient ID to update: ');
    final patient = patientService.getPatientById(id);
    if (patient == null) {
      print('Patient not found.');
      return;
    }

    print('Enter new details (leave blank to keep current value):');
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
      address: address.isNotEmpty ? address : patient.address,
      medicalSummary: patient.medicalSummary,
    );

    patientService.updatePatient(updatedPatient);
    print('Patient updated successfully.');
  }

  void viewAppointmentHistory() {
    final patientId = readId('Enter Patient ID to view history: ');
    final history = patientService.getPatientAppointmentHistory(patientId);
    if (history.isEmpty) {
      print('No appointment history found.');
      return;
    }
    print('\n--- Appointment History for $patientId ---');
    history.forEach((appt) {
      print('ID: ${appt.id}, Doctor: ${appt.doctorId}, Date: ${formatDate(appt.dateTime)}, Status: ${appt.status}');
    });
  }
}
