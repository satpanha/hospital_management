import '../../domain/models/appointment.dart';
import '../../domain/models/patient.dart';
import '../../domain/models/staff.dart';

class InMemoryDataSource {
  final List<Patient> _patients = [];
  final List<Staff> _staff = [];
  final List<Appointment> _appointments = [];

  // Patient Data
  List<Patient> get patients => _patients;
  void addPatient(Patient p) => _patients.add(p);
  void updatePatient(Patient p) {
    final index = _patients.indexWhere((patient) => patient.id == p.id);
    if (index != -1) {
      _patients[index] = p;
    }
  }

  // Staff Data
  List<Staff> get staff => _staff;
  void addStaff(Staff s) => _staff.add(s);
  void updateStaff(Staff s) {
    final index = _staff.indexWhere((staff) => staff.id == s.id);
    if (index != -1) {
      _staff[index] = s;
    }
  }
  
  // Appointment Data
  List<Appointment> get appointments => _appointments;
  void addAppointment(Appointment a) => _appointments.add(a);
  void updateAppointment(Appointment a) {
    final index = _appointments.indexWhere((appt) => appt.id == a.id);
    if (index != -1) {
      _appointments[index] = a;
    }
  }
}