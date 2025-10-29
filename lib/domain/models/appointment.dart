enum AppointmentStatus { Scheduled, Completed, Cancelled, NoShow }

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  AppointmentStatus status;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    this.status = AppointmentStatus.Scheduled,
  });
}