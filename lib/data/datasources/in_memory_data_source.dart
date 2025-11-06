import 'dart:convert';
import 'dart:io';

import '../../domain/models/appointment.dart';
import '../../domain/models/patient.dart';
import '../../domain/models/staff.dart';

class InMemoryDataSource {
  // Internal data lists
  final List<Patient> _patients = [];
  final List<Staff> _staff = [];
  final List<Appointment> _appointments = [];

  static const String _dataDir = 'data';
  static const String _patientsFile = 'data/patients.json';
  static const String _staffFile = 'data/staff.json';
  static const String _appointmentsFile = 'data/appointments.json';

  InMemoryDataSource() {
    _ensureDataDirExists();
    loadAll();

    // If empty → create sample data
    if (_patients.isEmpty && _staff.isEmpty && _appointments.isEmpty) {
      _initializeSampleData();
      saveAll();
    }
  }

  void _ensureDataDirExists() {
    final dir = Directory(_dataDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  List<dynamic> _readJsonFile(String path) {
    final file = File(path);
    if (!file.existsSync()) return [];

    try {
      final raw = file.readAsStringSync();
      return jsonDecode(raw);
    } catch (_) {
      return []; // prevents crash on corrupted JSON
    }
  }

  void _writeJsonFile(String path, List<dynamic> jsonList) {
    File(path).writeAsStringSync(jsonEncode(jsonList), flush: true);
  }

  void loadAll() {
    loadPatients();
    loadStaff();
    loadAppointments();
  }

  void saveAll() {
    savePatients();
    saveStaff();
    saveAppointments();
  }

  void loadPatients() {
    final jsonList = _readJsonFile(_patientsFile);
    _patients
      ..clear()
      ..addAll(jsonList.map((e) => Patient.fromJson(e)));
  }

  void savePatients() {
    _writeJsonFile(_patientsFile, _patients.map((e) => e.toJson()).toList());
  }

  List<Patient> get patients => _patients;

  void addPatient(Patient p) {
    _patients.add(p);
    savePatients();
  }

  void updatePatient(Patient p) {
    final index = _patients.indexWhere((x) => x.id == p.id);
    if (index != -1) {
      _patients[index] = p;
      savePatients();
    }
  }

  void loadStaff() {
    final jsonList = _readJsonFile(_staffFile);
    _staff
      ..clear()
      ..addAll(jsonList.map((e) => Staff.fromJson(e)));
  }

  void saveStaff() {
    _writeJsonFile(_staffFile, _staff.map((e) => e.toJson()).toList());
  }

  List<Staff> get staff => _staff;

  void addStaff(Staff s) {
    _staff.add(s);
    saveStaff();
  }

  void updateStaff(Staff s) {
    final index = _staff.indexWhere((x) => x.id == s.id);
    if (index != -1) {
      _staff[index] = s;
      saveStaff();
    }
  }

  void loadAppointments() {
    final jsonList = _readJsonFile(_appointmentsFile);

    _appointments
      ..clear()
      ..addAll(jsonList.map((e) => Appointment.fromJson(e)));
  }

  void saveAppointments() {
    _writeJsonFile(
      _appointmentsFile,
      _appointments.map((e) => e.toJson()).toList(),
    );
  }

  List<Appointment> get appointments => _appointments;

  void addAppointment(Appointment a) {
    _appointments.add(a);
    saveAppointments();
  }

  void updateAppointment(Appointment a) {
    final index = _appointments.indexWhere((x) => x.id == a.id);
    if (index != -1) {
      _appointments[index] = a;
      saveAppointments();
    }
  }

  // Below is AI-Generate Code
  // === Initialization ===
  void _initializeSampleData() {
    // Sample Patients
    _patients.addAll([
      Patient(
        id: 'P001',
        name: 'John Doe',
        dob: DateTime(1985, 6, 15),
        contact: '0123456789',
        address: '123 Main Street, Phnom Penh',
      ),
      Patient(
        id: 'P002',
        name: 'Sokha Chan',
        dob: DateTime(1990, 2, 10),
        contact: '0987654321',
        address: '45 Norodom Blvd, Phnom Penh',
      ),
      Patient(
        id: 'P003',
        name: 'Lisa Kim',
        dob: DateTime(2000, 11, 25),
        contact: '0971122334',
        address: 'Siem Reap City',
      ),
      Patient(
        id: 'P004',
        name: 'Rith Dara',
        dob: DateTime(1975, 3, 5),
        contact: '0967788990',
        address: 'Battambang Province',
      ),
    ]);

    // Sample Staff
    _staff.addAll([
      Staff(
        id: 'D001',
        name: 'Dr. Dara Vann',
        dob: DateTime(1980, 5, 12),
        contact: '012345678',
        address: 'Phnom Penh, Cambodia',
        role: Role.doctor,
        specialization: 'Cardiology',
        availability: 'Mon-Fri 9am-4pm',
        password: '1234',
      ),
      Staff(
        id: 'D002',
        name: 'Dr. Kim Leng',
        dob: DateTime(1985, 3, 20),
        contact: '098765432',
        address: 'Siem Reap, Cambodia',
        role: Role.doctor,
        specialization: 'Pediatrics',
        availability: 'Mon-Sat 8am-5pm',
        password: '1234',
      ),
      Staff(
        id: 'N001',
        name: 'Nurse Srey Neang',
        dob: DateTime(1990, 10, 5),
        contact: '011223344',
        address: 'Battambang, Cambodia',
        role: Role.receptionist,
        specialization: 'Nursing',
        availability: 'Mon-Fri 7am-3pm',
        password: '1234',
      ),
      Staff(
        id: 'A001',
        name: 'Sok Phirun',
        dob: DateTime(1992, 7, 8),
        contact: '015667788',
        address: 'Kampot, Cambodia',
        role: Role.receptionist,
        specialization: 'Front Desk',
        availability: 'Mon-Fri 8am-5pm',
        password: '1234',
      ),
      Staff(
        id: '0000',
        name: 'Admin',
        dob: DateTime(1988, 1, 1),
        contact: '010000000',
        address: 'Phnom Penh, Cambodia',
        role: Role.admin,
        specialization: 'System Administration',
        availability: 'Mon-Fri 8am-5pm',
        password: '1234',
      ),
    ]);

    // Appointment Sample Data
    Staff getDoctor(String id) =>
        _staff.firstWhere((s) => s.id == id && s.role == Role.doctor);

    Patient getPatient(String id) =>
        _patients.firstWhere((p) => p.id == id);

    _appointments.addAll([
      Appointment(
        id: 'AP001',
        patient: getPatient('P001'),
        doctor: getDoctor('D001'),
        dateTime: DateTime.now().add(const Duration(hours: 1)),
        status: AppointmentStatus.scheduled,
      ),
      Appointment(
        id: 'AP002',
        patient: getPatient('P002'),
        doctor: getDoctor('D002'),
        dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        status: AppointmentStatus.completed,
      ),
      Appointment(
        id: 'AP003',
        patient: getPatient('P003'),
        doctor: getDoctor('D001'),
        dateTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        status: AppointmentStatus.scheduled,
      ),
      Appointment(
        id: 'AP004',
        patient: getPatient('P004'),
        doctor: getDoctor('D002'),
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        status: AppointmentStatus.completed,
      ),
      Appointment(
        id: 'AP005',
        patient: getPatient('P002'),
        doctor: getDoctor('D001'),
        dateTime: DateTime.now().add(const Duration(days: 2)),
        status: AppointmentStatus.cancelled,
      ),
      Appointment(
        id: 'AP006',
        patient: getPatient('P001'),
        doctor: getDoctor('D002'),
        dateTime: DateTime.now().subtract(const Duration(days: 5)),
        status: AppointmentStatus.noShow,
      ),
    ]);
  }
}
