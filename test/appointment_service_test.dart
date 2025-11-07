//appointment_service_test.dart
import 'package:hostpital_management/domain/models/appointment.dart';
import 'package:hostpital_management/domain/models/patient.dart';
import 'package:hostpital_management/domain/models/staff.dart';
import 'package:hostpital_management/domain/services/appointment_service.dart';
import 'package:hostpital_management/data/repositories/appointment_repository.dart';
import 'package:hostpital_management/data/repositories/patient_repository.dart';
import 'package:hostpital_management/data/repositories/staff_repository.dart';
import 'package:hostpital_management/data/datasources/in_memory_data_source.dart';
import 'package:test/test.dart';

void main() {
  late AppointmentService appointmentService;
  late AppointmentRepository appointmentRepository;
  late PatientRepository patientRepository;
  late StaffRepository staffRepository;
  late Patient patient;
  late Staff doctor;
  late Patient patient2;

  setUp(() {
    final dataSource = InMemoryDataSource();
    appointmentRepository = AppointmentRepository(dataSource);
    patientRepository = PatientRepository(dataSource);
    staffRepository = StaffRepository(dataSource);

    appointmentService = AppointmentService(
      appointmentRepository,
      staffRepository,
      patientRepository,
    );
    patient2 = Patient(
      id: 'p3',
      name: 'Chai Chan',
      dob: DateTime(1999, 1, 1),
      contact: '1234536',
      address: '6A',
    );

    patient = Patient(
      id: 'p1',
      name: 'Dara Chan',
      dob: DateTime(1990, 1, 1),
      contact: '123456',
      address: '6A',
    );
    doctor = Staff(
      id: 'd1',
      name: 'Dr. Sok',
      dob: DateTime(1980, 2, 2),
      contact: '999999',
      address: 'Clinic A',
      role: Role.doctor,
      specialization: 'Cardiology',
      password: '1234',
    );

    patientRepository.addPatient(patient);
    patientRepository.addPatient(patient2);
    staffRepository.add(doctor);
  });

  test('should book appointment successfully', () {
    final appointment = appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime(2025, 11, 10, 10, 0),
    );

    expect(appointment.patient.id, equals(patient.id));
    expect(appointment.doctor.id, equals(doctor.id));
  });

  test('should cancel an appointment', () {
    final appt = appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime(2025, 11, 10, 10, 0),
    );

    appointmentService.cancelAppointment(appt.id);
    final updated = appointmentRepository.getById(appt.id);

    expect(updated?.status, AppointmentStatus.cancelled);
  });

  test('should reschedule an appointment', () {
    final appt = appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime(2025, 11, 10, 10, 0),
    );

    appointmentService.rescheduleAppointment(
      appt.id,
      DateTime(2025, 11, 11, 14, 0),
    );
    final updated = appointmentRepository.getById(appt.id);

    expect(updated?.dateTime, DateTime(2025, 11, 11, 14, 0));
  });

  test('should mark appointment as completed', () {
    final appt = appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime(2025, 11, 10, 10, 0),
    );

    appointmentService.markAppointmentCompleted(appt.id, 'Follow up next week');
    final updated = appointmentRepository.getById(appt.id);

    expect(updated?.status, AppointmentStatus.completed);
    expect(updated?.notes, 'Follow up next week');
  });

  test('should mark appointment as no-show', () {
    final appt = appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime(2025, 11, 10, 10, 0),
    );

    appointmentService.markAppointmentNoShow(appt.id);
    final updated = appointmentRepository.getById(appt.id);

    expect(updated?.status, AppointmentStatus.noShow);
  });

  test('should throw exception when booking conflict for doctor', () {
    appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime(2025, 11, 10, 10, 0),
    );

    expect(
      () => appointmentService.bookAppointment(
        'p2',
        doctor.id,
        DateTime(2025, 11, 10, 10, 0),
      ),
      throwsA(
        predicate(
          (e) =>
              e is Exception &&
              e.toString().contains(
                'Doctor already has an appointment at this time',
              ),
        ),
      ),
    );
  });

  test('should throw exception when booking appointment in the past', () {
    final pastTime = DateTime.now().subtract(const Duration(hours: 2));
    expect(
      () => appointmentService.bookAppointment(patient.id, doctor.id, pastTime),
      throwsA(
        predicate(
          (e) =>
              e is Exception &&
              e.toString().contains('Cannot book an appointment in the past'),
        ),
      ),
    );
  });

  test('should remove completed appointment from doctor schedule', () {
    final appt = appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime(2025, 11, 10, 10, 0),
    );

    final beforeSchedule = appointmentRepository.getByDoctorAndDate(
      doctor.id,
      appt.dateTime,
    );
    expect(beforeSchedule.length, 1);

    appointmentService.markAppointmentCompleted(appt.id, 'All good');

    final afterSchedule = appointmentRepository.getByDoctorAndDate(
      doctor.id,
      appt.dateTime,
    );
    expect(
      afterSchedule.any((a) => a.status == AppointmentStatus.scheduled),
      isFalse,
      reason:
          'Completed appointments should be removed from doctor active schedule',
    );
  });

  test('should return doctor schedule with all appointments', () {
    final appt1 = appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime(2025, 11, 10, 9, 0),
    );
    final appt2 = appointmentService.bookAppointment(
      patient2.id,
      doctor.id,
      DateTime(2025, 11, 10, 11, 0),
    );

    final schedule = appointmentService.getDoctorSchedule(doctor.id);

    expect(schedule.length, 2);
    expect(schedule.any((a) => a.id == appt1.id), isTrue);
    expect(schedule.any((a) => a.id == appt2.id), isTrue);
  });
  test('should return doctor schedule with all appointments', () {
    appointmentService.bookAppointment(
      patient.id,
      doctor.id,
      DateTime.now().add(Duration(days: 1)),
    );
    appointmentService.bookAppointment(
      patient2.id,
      doctor.id,
      DateTime.now().add(Duration(days: 2)),
    );

    final schedule = appointmentService.getDoctorSchedule(doctor.id);
    expect(schedule.length, 2);
  });
}
