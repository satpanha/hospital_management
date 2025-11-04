import '../../domain/models/appointment.dart';
import '../../domain/models/patient.dart';
import '../../domain/models/staff.dart';

class InMemoryDataSource {
  final List<Patient> _patients = [];
  final List<Staff> _staff = [];
  final List<Appointment> _appointments = [];

  InMemoryDataSource() {
    _initializeSampleData();
  }

  List<Patient> get patients => _patients;
  void addPatient(Patient p) => _patients.add(p);

  void updatePatient(Patient p) {
    final index = _patients.indexWhere((patient) => patient.id == p.id);
    if (index != -1) _patients[index] = p;
  }

  List<Staff> get staff => _staff;
  void addStaff(Staff s) => _staff.add(s);

  void updateStaff(Staff s) {
    final index = _staff.indexWhere((staff) => staff.id == s.id);
    if (index != -1) _staff[index] = s;
  }

  List<Appointment> get appointments => _appointments;
  void addAppointment(Appointment a) => _appointments.add(a);

  void updateAppointment(Appointment a) {
    final index = _appointments.indexWhere((appt) => appt.id == a.id);
    if (index != -1) _appointments[index] = a;
  }

  void _initializeSampleData() {
    _patients.addAll([
      Patient(
        id: 'P001',
        name: 'John Doe',
        dob: DateTime(1985, 6, 15),
        contact: '0123456789',
        address: '123 Main Street, Phnom Penh',
        medicalSummary: 'Diabetic, on insulin therapy.',
      ),
      Patient(
        id: 'P002',
        name: 'Sokha Chan',
        dob: DateTime(1990, 2, 10),
        contact: '0987654321',
        address: '45 Norodom Blvd, Phnom Penh',
        medicalSummary: 'High blood pressure; under control.',
      ),
      Patient(
        id: 'P003',
        name: 'Lisa Kim',
        dob: DateTime(2000, 11, 25),
        contact: '0971122334',
        address: 'Siem Reap City',
        medicalSummary: 'No major medical history.',
      ),
    ]);

    _staff.addAll([
      Staff(
        id: 'D001',
        name: 'Dr. Dara Vann',
        role: 'Doctor',
        availability: 'Mon-Fri 9am-4pm',
      ),
      Staff(
        id: 'D002',
        name: 'Dr. Kim Leng',
        role: 'Doctor',
        availability: 'Mon-Sat 8am-5pm',
      ),
      Staff(
        id: 'N001',
        name: 'Nurse Srey Neang',
        role: 'Nurse',
        availability: 'Mon-Fri 7am-3pm',
      ),
      Staff(
        id: 'A001',
        name: 'Sok Phirun',
        role: 'Admin',
        availability: 'Mon-Fri 8am-5pm',
      ),
    ]);

    // Sample Appointment
    _appointments.add(
      Appointment(
        id: 'AP001',
        patientId: 'P001',
        doctorId: 'D001',
        dateTime: DateTime.now().add(const Duration(hours: 1)),
        status: AppointmentStatus.scheduled,
      ),
    );
  }
}