import '../../domain/models/appointment.dart';
import '../datasources/in_memory_data_source.dart';

class AppointmentRepository {
  final InMemoryDataSource dataSource;

  AppointmentRepository(this.dataSource);

  void add(Appointment a) {
    dataSource.addAppointment(a);
  }

  Appointment? getById(String id) {
    try {
      return dataSource.appointments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Appointment> getByPatientId(String patientId) {
    return dataSource.appointments
        .where((a) => a.patient.id == patientId)
        .toList();
  }

  List<Appointment> getByDoctorAndDate(String doctorId, DateTime date) {
    return dataSource.appointments.where((a) {
      return a.doctor.id == doctorId &&
          a.dateTime.year == date.year &&
          a.dateTime.month == date.month &&
          a.dateTime.day == date.day;
    }).toList();
  }

  List<Appointment> getByDoctor(String doctorId) {
    return dataSource.appointments.where((a) => a.doctor.id == doctorId).toList();
  }

  void update(Appointment a) {
    dataSource.updateAppointment(a);
  }
}

