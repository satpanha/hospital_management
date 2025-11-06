import 'package:test/test.dart';
import 'package:hospital_management/data/datasources/in_memory_data_source.dart';
import 'package:hospital_management/domain/models/appointment.dart';
import 'package:hospital_management/domain/services/appointment_service.dart';

void main() {
  group('AppointmentService Tests', () {
    late InMemoryDataSource dataSource;
    late AppointmentService service;

    setUp(() {
      dataSource = InMemoryDataSource();
      service = AppointmentService(dataSource);
    });

    test('should return all appointments', () {
      final appointments = service.getAllAppointments();
      expect(appointments.isNotEmpty, true);
    });

    test('should add new appointment', () {
      final patient = dataSource.patients.first;
      final doctor = dataSource.staff.firstWhere((s) => s.role == Role.doctor);

      final appointment = Appointment(
        id: 'AX01',
        patient: patient,
        doctor: doctor,
        dateTime: DateTime.now(),
        status: AppointmentStatus.scheduled,
      );

      service.addAppointment(appointment);

      final all = service.getAllAppointments();
      expect(all.any((a) => a.id == 'AX01'), true);
    });

    test('should update existing appointment', () {
      final first = service.getAllAppointments().first;

      final updated = Appointment(
        id: first.id,
        patient: first.patient,
        doctor: first.doctor,
        dateTime: first.dateTime.add(const Duration(hours: 2)),
        status: AppointmentStatus.completed,
      );

      service.updateAppointment(updated);

      final after =
          service.getAllAppointments().firstWhere((a) => a.id == first.id);

      expect(after.status, AppointmentStatus.completed);
    });
  });
}
