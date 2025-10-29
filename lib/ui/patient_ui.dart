import 'dart:io';
import '../domain/models/patient.dart';
import '../domain/services/patient_service.dart';
import '../utils/date_utils.dart';

class PatientUI {
  final PatientService patientService;

  PatientUI(this.patientService);

  void displayPatientMenu() {
    while (true) {
      print('\n--- Patient Management ---');
      print('1. Register New Patient');
      print('2. Search/View Patient');
      print('3. Update Patient Details');
      print('4. View All Patients');
      print('5. View Patient Appointment History');
      print('6. Back to Main Menu');
      stdout.write('Enter your choice: ');

      final choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          registerNewPatient();
          break;
        case '2':
          searchPatient();
          break;
        case '3':
          updatePatient();
          break;
        case '4':
          listAllPatients();
          break;
        case '5':
          viewAppointmentHistory();
          break;
        case '6':
          return;
        default:
          print('Invalid choice.');
      }
    }
  }

  void registerNewPatient() {
    print('\n--- Register New Patient ---');
    stdout.write('Enter Name: ');
    final name = stdin.readLineSync()!;
    stdout.write('Enter Date of Birth (YYYY-MM-DD): ');
    final dob = DateTime.parse(stdin.readLineSync()!);
    stdout.write('Enter Contact Number: ');
    final contact = stdin.readLineSync()!;
    stdout.write('Enter Address: ');
    final address = stdin.readLineSync()!;
    stdout.write('Enter Medical Summary: ');
    final summary = stdin.readLineSync()!;

    final patient = patientService.registerPatient(name, dob, contact, address, summary);
    print('Patient registered successfully with ID: ${patient.id}');
  }

  void searchPatient() {
    stdout.write('Enter Patient ID, Name, or Phone to search: ');
    final query = stdin.readLineSync()!;
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
    stdout.write('Enter Patient ID to update: ');
    final id = stdin.readLineSync()!;
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
      dob: patient.dob, // DOB is not usually updated
      contact: contact.isNotEmpty ? contact : patient.contact,
      address: address.isNotEmpty ? address : patient.address,
      medicalSummary: patient.medicalSummary, // Simplified
    );

    patientService.updatePatient(updatedPatient);
    print('Patient details updated successfully.');
  }

  void viewAppointmentHistory() {
    stdout.write('Enter Patient ID to view history: ');
    final patientId = stdin.readLineSync()!;
    final history = patientService.getPatientAppointmentHistory(patientId);

    if (history.isEmpty) {
      print('No appointment history found for this patient.');
      return;
    }

    print('\n--- Appointment History for Patient ID: $patientId ---');
    history.forEach((appt) {
      print('ID: ${appt.id}, Doctor ID: ${appt.doctorId}, Date: ${formatDate(appt.dateTime)}, Status: ${appt.status}');
    });
  }
}