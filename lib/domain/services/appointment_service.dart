import 'package:hostpital_management/domain/models/staff.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/staff_repository.dart';
import '../../utils/id_generator.dart';
import '../models/appointment.dart';

class AppointmentService {
  final AppointmentRepository appointmentRepository;
  final StaffRepository staffRepository;

  AppointmentService(this.appointmentRepository, this.staffRepository);

  Appointment bookAppointment(String patientId, String doctorId, DateTime dateTime) {
    final existingAppointments = appointmentRepository.getByDoctorAndDate(doctorId, dateTime);
    if (existingAppointments.any((appt) => appt.dateTime == dateTime)) {
      throw Exception('Time slot is already booked.');
    }

    final doctor = staffRepository.getById(doctorId);
    if (doctor == null || doctor.role != Role.doctor) {
      throw Exception('Invalid Doctor ID.');
    }

    final newAppointment = Appointment(
      id: IdGenerator.generate(),
      patientId: patientId,
      doctorId: doctorId,
      dateTime: dateTime,
    );

    appointmentRepository.add(newAppointment);
    return newAppointment;
  }

  void cancelAppointment(String appointmentId) {
    final appointment = appointmentRepository.getById(appointmentId);
    if (appointment == null) throw Exception('Appointment not found.');

    appointment.status = AppointmentStatus.cancelled;
    appointmentRepository.update(appointment);
  }

  void rescheduleAppointment(String appointmentId, DateTime newDateTime) {
    final appointment = appointmentRepository.getById(appointmentId);
    if (appointment == null) throw Exception('Appointment not found.');

    final existingAppointments =
        appointmentRepository.getByDoctorAndDate(appointment.doctorId, newDateTime);
    if (existingAppointments.any((appt) => appt.dateTime == newDateTime && appt.id != appointmentId)) {
      throw Exception('New time slot is already booked.');
    }

    appointmentRepository.update(Appointment(
      id: appointment.id,
      patientId: appointment.patientId,
      doctorId: appointment.doctorId,
      dateTime: newDateTime,
      status: AppointmentStatus.scheduled,
    ));
  }

  List<Appointment> getDoctorSchedule(String doctorId) {
    return appointmentRepository.getByDoctor(doctorId);
  }

  void markAppointmentCompleted(String appointmentId, String notes) {
    final appointment = appointmentRepository.getById(appointmentId);
    if (appointment == null) throw Exception('Appointment not found.');

    appointment.status = AppointmentStatus.completed;
    appointment.notes = notes;
    appointmentRepository.update(appointment);
  }

  void markAppointmentNoShow(String appointmentId) {
    final appointment = appointmentRepository.getById(appointmentId);
    if (appointment == null) throw Exception('Appointment not found.');

    appointment.status = AppointmentStatus.noShow;
    appointmentRepository.update(appointment);
  }
}
