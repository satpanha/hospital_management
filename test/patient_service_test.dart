//patient_service_test.dart
import 'package:hostpital_management/domain/models/patient.dart';
import 'package:hostpital_management/domain/services/patient_service.dart';
import 'package:hostpital_management/domain/models/staff.dart';
import 'package:hostpital_management/domain/models/appointment.dart';
import 'package:hostpital_management/data/repositories/patient_repository.dart';
import 'package:hostpital_management/data/repositories/appointment_repository.dart';
import 'package:hostpital_management/data/repositories/staff_repository.dart';
import 'package:hostpital_management/data/datasources/in_memory_data_source.dart';
import 'package:test/test.dart';

void main() {
  late PatientService patientService;
  late PatientRepository patientRepository;
  late AppointmentRepository appointmentRepository;
  late StaffRepository staffRepository;
  late Staff doctor;

  setUp(() {
    final dataSource = InMemoryDataSource();
    patientRepository = PatientRepository(dataSource);
    appointmentRepository = AppointmentRepository(dataSource);
    staffRepository = StaffRepository(dataSource);
    patientService = PatientService(patientRepository, appointmentRepository);

    doctor = Staff(
      id: 'd1',
      name: 'Dr. Sok',
      dob: DateTime(1980, 2, 2),
      contact: '999',
      address: 'Clinic A',
      role: Role.doctor,
      specialization: 'Cardiology',
      password: '1234',
    );

    staffRepository.add(doctor);
  });

  test('should register a new patient', () {
    final patient = patientService.registerPatient(
      'Alice',
      DateTime(1995, 5, 5),
      '0123456',
      'Phnom Penh',
    );

    expect(patientRepository.getById(patient.id), isNotNull);
  });

  test('should retrieve patient by id', () {
    final p = patientService.registerPatient(
      'Bob',
      DateTime(1999, 1, 1),
      '444',
      'City',
    );
    final result = patientService.getPatientById(p.id);

    expect(result?.name, 'Bob');
  });

  test('should retrieve patient by phoneNumber', () {
    final p = patientService.registerPatient(
      'Bob',
      DateTime(1999, 1, 1),
      '444',
      'City',
    );
    final result = patientService.getPatientByPhoneNumber(p.contact);

    expect(result?.name, 'Bob');
  });

  test('should update patient information', () {
    final p = patientService.registerPatient(
      'Charlie',
      DateTime(1990, 3, 3),
      '222',
      'Old',
    );
    p.address = 'New Address';
    patientService.updatePatient(p);
    expect(patientRepository.getById(p.id)?.address, 'New Address');
  });

  test(
    'should return appointment history when patient already has booked appointments',
    () {
      // Register patient
      final patient = patientService.registerPatient(
        'Dara Chan',
        DateTime(1998, 8, 8),
        '555',
        'Phnom Penh',
      );

      final appointment1 = Appointment(
        id: 'a1',
        patient: patient,
        doctor: doctor,
        dateTime: DateTime(2025, 11, 10, 10, 0),
      );

      final appointment2 = Appointment(
        id: 'a2',
        patient: patient,
        doctor: doctor,
        dateTime: DateTime(2025, 11, 12, 14, 0),
        status: AppointmentStatus.completed,
        notes: 'Checkup done',
      );

      appointmentRepository.add(appointment1);
      appointmentRepository.add(appointment2);

      final history = patientService.getPatientAppointmentHistory(patient.id);

      expect(history.length, 2);
      expect(history[0].patient.id, equals(patient.id));
      expect(
        history.any((appt) => appt.status == AppointmentStatus.completed),
        isTrue,
      );
    },
  );

  test('should return all patients', () {
    final all = patientService.getAllPatients();
    expect(all, isA<List<Patient>>());
    expect(all.isNotEmpty, isTrue);
  });
}
