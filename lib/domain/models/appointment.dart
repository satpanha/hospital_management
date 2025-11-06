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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patient.id,
      'doctorId': doctor.id,
      'dateTime': dateTime.toIso8601String(),
      'status': status.toString().split('.').last,
      'notes': notes,
      'medical': medical,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json, Patient patient, Staff doctor) {
    return Appointment(
      id: json['id'],
      patient: patient,
      doctor: doctor,
      dateTime: DateTime.parse(json['dateTime']),
      status: AppointmentStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
          orElse: () => AppointmentStatus.scheduled),
      notes: json['notes'],
      medical: json['medical'],
    );
  }

  void validate() {
    if (id.isEmpty) throw ArgumentError('Appointment ID cannot be empty');
    if (patientId.isEmpty) throw ArgumentError('Patient ID cannot be empty');
    if (doctorId.isEmpty) throw ArgumentError('Doctor ID cannot be empty');
    if (dateTime.isBefore(DateTime.now())) throw ArgumentError('Appointment date cannot be in the past');
  }  

  @override
  String toString() {
    return 'Appointment(id: $id, patient: ${patient.name}, doctor: ${doctor.name}, '
            'date: $dateTime, status: $status, notes: ${notes ?? "none"} medical: ${medical ?? "none"})';
  }
}
