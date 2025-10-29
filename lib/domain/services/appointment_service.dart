import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/staff_repository.dart';
import '../../utils/id_generator.dart';
import '../models/appointment.dart';

class AppointmentService {
  final AppointmentRepository appointmentRepository;
  final StaffRepository staffRepository;

  AppointmentService(this.appointmentRepository, this.staffRepository);

  Appointment bookAppointment(String patientId, String doctorId, DateTime dateTime) {
    // Business Rule: Check for scheduling conflicts
    final existingAppointments = appointmentRepository.getByDoctorAndDate(doctorId, dateTime);
    if (existingAppointments.any((appt) => appt.dateTime == dateTime)) {
      throw Exception('Time slot is already booked.');
    }
    
    // Business Rule: Check if doctor is available (simplified)
    final doctor = staffRepository.getById(doctorId);
    if(doctor == null || doctor.role.toLowerCase() != 'doctor') {
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
    if (appointment == null) {
      throw Exception('Appointment not found.');
    }
    appointment.status = AppointmentStatus.Cancelled;
    appointmentRepository.update(appointment);
  }
  
  void rescheduleAppointment(String appointmentId, DateTime newDateTime) {
     final appointment = appointmentRepository.getById(appointmentId);
    if (appointment == null) {
      throw Exception('Appointment not found.');
    }
    
    // Check for conflicts at the new time
    final existingAppointments = appointmentRepository.getByDoctorAndDate(appointment.doctorId, newDateTime);
    if (existingAppointments.any((appt) => appt.dateTime == newDateTime && appt.id != appointmentId)) {
      throw Exception('New time slot is already booked.');
    }

    final updatedAppointment = Appointment(
      id: appointment.id,
      patientId: appointment.patientId,
      doctorId: appointment.doctorId,
      dateTime: newDateTime,
      status: AppointmentStatus.Scheduled,
    );
    
    appointmentRepository.update(updatedAppointment);
  }
  
  List<Appointment> getDoctorSchedule(String doctorId, DateTime date) {
    return appointmentRepository.getByDoctorAndDate(doctorId, date);
  }
}