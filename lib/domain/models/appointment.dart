import 'package:hostpital_management/domain/models/patient.dart';
import 'package:hostpital_management/domain/models/staff.dart';

enum AppointmentStatus { scheduled, completed, cancelled, noShow }

class Appointment {
  final String id;
  final Patient patient;
  final Staff doctor;
  DateTime dateTime;
  String? medical;
  AppointmentStatus status;
  String? notes;

  Appointment({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.dateTime,
    this.status = AppointmentStatus.scheduled,
    this.notes,
    this.medical,
  });

  @override
  String toString() {
    return 'Appointment(id: $id, patient: ${patient.name}, doctor: ${doctor.name}, '
            'date: $dateTime, status: $status, notes: ${notes ?? "none"} medical: ${medical ?? "none"})';
  }
}
