// import 'package:hostpital_management/appointment_system.dart' as hostpital_management;
import 'dart:io';

import 'package:hostpital_management/appointment_system.dart';

List<Doctor> doctors = [];
List<Patient> patients = [];
List<Appointment> appointments = [];
void main(List<String> arguments) {

  print("=== 🏥 Welcome to Hospital Appointment System ===");

  while (true) {
    print("\nLogin as:");
    print("1. Administrator");
    print("2. Doctor");
    print("3. Patient");
    print("4. Exit");
    stdout.write("Select role: ");
    String? role = stdin.readLineSync();

    switch (role) {
      case '1':
        adminPanel();
        break;
      case '2':
        doctorPanel();
        break;
      case '3':
        patientPanel();
        break;
      case '4':
        print("👋 Goodbye!");
        return;
      default:
        print("❌ Invalid option, please try again.");
    }
  }
}

// ================= ADMIN PANEL =================
void adminPanel() {
  print("\n=== 👑 Administrator Panel ===");

  while (true) {
    print("\n1. Register Doctor");
    print("2. Register Patient");
    print("3. View All Doctors");
    print("4. View All Patients");
    print("5. View All Appointments");
    print("6. Delete Doctor or Patient");
    print("7. Back to Main Menu");
    stdout.write("Select: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write("Enter Doctor ID: ");
        String id = stdin.readLineSync()!;
        stdout.write("Enter Name: ");
        String name = stdin.readLineSync()!;
        stdout.write("Enter Gender: ");
        String gender = stdin.readLineSync()!;
        stdout.write("Enter Phone: ");
        String phone = stdin.readLineSync()!;
        stdout.write("Enter Specialty: ");
        String specialty = stdin.readLineSync()!;
        stdout.write("Set Password: ");
        String password = stdin.readLineSync()!;

        doctors.add(Doctor(
          id: id,
          name: name,
          gender: gender,
          phoneNumber: phone,
          hireDate: DateTime.now(),
          dob: DateTime(1980, 1, 1),
          password: password,
          role: "Doctor",
          specialty: specialty, phoneNUmber: '',
        ));

        print("✅ Doctor Registered!");
        break;

      case '2':
        stdout.write("Enter Patient ID: ");
        String id = stdin.readLineSync()!;
        stdout.write("Enter Name: ");
        String name = stdin.readLineSync()!;
        stdout.write("Enter Gender: ");
        String gender = stdin.readLineSync()!;
        stdout.write("Enter Phone: ");
        String phone = stdin.readLineSync()!;
        stdout.write("Enter Address: ");
        String address = stdin.readLineSync()!;
        stdout.write("Set Password: ");
        String password = stdin.readLineSync()!;

        patients.add(Patient(
          id: id,
          name: name,
          gender: gender,
          dob: DateTime(2000, 1, 1),
          phoneNumber: phone,
          address: address,
          medicalHistory: "None",
        ));
        print("✅ Patient Registered!");
        break;

      case '3':
        if (doctors.isEmpty) {
          print("⚠️ No doctors registered.");
        } else {
          print("\n=== Doctors ===");
          for (var d in doctors) {
            print("ID: ${d.id} | Name: ${d.name} | Specialty: ${d.specialty}");
          }
        }
        break;

      case '4':
        if (patients.isEmpty) {
          print("⚠️ No patients registered.");
        } else {
          print("\n=== Patients ===");
          for (var p in patients) {
            print("ID: ${p.id} | Name: ${p.name} | Phone: ${p.phoneNumber}");
          }
        }
        break;

      case '5':
        if (appointments.isEmpty) {
          print("⚠️ No appointments yet.");
        } else {
          print("\n=== Appointments ===");
          for (var a in appointments) {
            print(
                "ID: ${a.id} | Doctor: ${a.doctor.name} | Patient: ${a.patient.name} | Status: ${a.status}");
          }
        }
        break;

      case '6':
        stdout.write("Delete (1) Doctor or (2) Patient: ");
        String? delChoice = stdin.readLineSync();
        if (delChoice == '1') {
          stdout.write("Enter Doctor ID: ");
          String id = stdin.readLineSync()!;
          doctors.removeWhere((d) => d.id == id);
          print("🗑️ Doctor deleted.");
        } else {
          stdout.write("Enter Patient ID: ");
          String id = stdin.readLineSync()!;
          patients.removeWhere((p) => p.id == id);
          print("🗑️ Patient deleted.");
        }
        break;

      case '7':
        return;
      default:
        print("❌ Invalid option.");
    }
  }
}

// ================= DOCTOR PANEL =================
void doctorPanel() {
  stdout.write("\nEnter Doctor ID: ");
  String id = stdin.readLineSync()!;
  stdout.write("Enter Password: ");
  String pass = stdin.readLineSync()!;

  Doctor? doctor =
      doctors.firstWhere((d) => d.id == id && d.password == pass, orElse: () => Doctor(
        id: '',
        name: '',
        gender: '',
        phoneNumber: '',
        hireDate: DateTime.now(),
        dob: DateTime.now(),
        password: '',
        role: '',
        specialty: '',
        phoneNUmber: ''
      ));

  if (doctor.id == '') {
    print("❌ Invalid credentials.");
    return;
  }

  print("\n=== 👨‍⚕️ Welcome Dr. ${doctor.name} ===");
  while (true) {
    print("\n1. View My Appointments");
    print("2. Accept or Reject Appointment");
    print("3. Mark Appointment Completed");
    print("4. View My Patients");
    print("5. Logout");
    stdout.write("Select: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        var myAppointments =
            appointments.where((a) => a.doctor.id == doctor.id).toList();
        if (myAppointments.isEmpty) {
          print("No appointments found.");
        } else {
          for (var a in myAppointments) {
            print(
                "ID: ${a.id} | Patient: ${a.patient.name} | Status: ${a.status}");
          }
        }
        break;

      case '2':
        stdout.write("Enter Appointment ID to accept/reject: ");
        String id = stdin.readLineSync()!;
        var appt = appointments.firstWhere((a) => a.id == id,
            orElse: () => Appointment(
                  id: '',
                  date: DateTime.now(),
                  note: '',
                  status: '',
                  doctor: doctor,
                  patient: patients.first,
                ));
        if (appt.id == '') {
          print("Appointment not found.");
        } else {
          stdout.write("Accept (A) or Reject (R)? ");
          String? act = stdin.readLineSync();
          if (act?.toUpperCase() == 'A') {
            appt.status = "Accepted";
          } else {
            appt.status = "Rejected";
          }
          print("✅ Appointment updated.");
        }
        break;

      case '3':
        stdout.write("Enter Appointment ID to mark completed: ");
        String id = stdin.readLineSync()!;
        var appt = appointments.firstWhere((a) => a.id == id,
            orElse: () => Appointment(
                  id: '',
                  date: DateTime.now(),
                  note: '',
                  status: '',
                  doctor: doctor,
                  patient: patients.first,
                ));
        if (appt.id == '') {
          print("Not found.");
        } else {
          appt.markCompleted();
        }
        break;

      case '4':
        var myPatients = appointments
            .where((a) => a.doctor.id == doctor.id)
            .map((a) => a.patient.name)
            .toSet();
        print("👥 My Patients: ${myPatients.join(', ')}");
        break;

      case '5':
        return;

      default:
        print("Invalid option.");
    }
  }
}

// ================= PATIENT PANEL =================
void patientPanel() {
  stdout.write("\nEnter Patient ID: ");
  String id = stdin.readLineSync()!;
  Patient? patient = patients.firstWhere((p) => p.id == id,
      orElse: () => Patient(
            id: '',
            name: '',
            gender: '',
            dob: DateTime.now(),
            phoneNumber: '',
            address: '',
            medicalHistory: '',
          ));

  if (patient.id == '') {
    print("❌ Patient not found.");
    return;
  }

  print("\n=== 🙍‍♂️ Welcome ${patient.name} ===");

  while (true) {
    print("\n1. View Doctors");
    print("2. Book Appointment");
    print("3. View My Appointments");
    print("4. Cancel Appointment");
    print("5. Logout");
    stdout.write("Select: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        for (var d in doctors) {
          print("Dr. ${d.name} (${d.specialty})");
        }
        break;

      case '2':
        stdout.write("Enter Doctor ID: ");
        String docId = stdin.readLineSync()!;
        Doctor? doctor = doctors.firstWhere((d) => d.id == docId,
            orElse: () => Doctor(
                  id: '',
                  name: '',
                  gender: '',
                  phoneNumber: '',
                  hireDate: DateTime.now(),
                  dob: DateTime.now(),
                  password: '',
                  role: '',
                  specialty: '',
                  phoneNUmber: ''
                ));
        if (doctor.id == '') {
          print("Doctor not found.");
          break;
        }

        stdout.write("Enter Reason: ");
        String reason = stdin.readLineSync()!;
        var appointment = Appointment(
          id: "A${appointments.length + 1}",
          date: DateTime.now().add(Duration(days: 1)),
          note: reason,
          status: "Pending",
          doctor: doctor,
          patient: patient,
        );
        appointments.add(appointment);
        print("✅ Appointment booked with Dr. ${doctor.name}");
        break;

      case '3':
        var myAppointments =
            appointments.where((a) => a.patient.id == patient.id).toList();
        if (myAppointments.isEmpty) {
          print("No appointments found.");
        } else {
          for (var a in myAppointments) {
            print(
                "ID: ${a.id} | Doctor: ${a.doctor.name} | Status: ${a.status}");
          }
        }
        break;

      case '4':
        stdout.write("Enter Appointment ID to cancel: ");
        String id = stdin.readLineSync()!;
        var appt = appointments.firstWhere((a) => a.id == id,
            orElse: () => Appointment(
                  id: '',
                  date: DateTime.now(),
                  note: '',
                  status: '',
                  doctor: doctors.first,
                  patient: patient,
                ));
        if (appt.id == '') {
          print("Not found.");
        } else {
          appt.cancel();
        }
        break;

      case '5':
        return;
      default:
        print("Invalid choice.");
    }
  }
}
