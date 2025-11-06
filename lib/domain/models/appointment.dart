enum AppointmentStatus {
  scheduled,
  completed,
  cancelled,
  noShow,
}

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  String? medical;
  AppointmentStatus status;
  String? notes; 

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    this.status = AppointmentStatus.scheduled,
    this.notes,
    this.medical
  });

  @override
  String toString() {
    return 'Appointment(id: $id, patient: $patientId, doctor: $doctorId, '
        'date: $dateTime, status: $status, notes: ${notes ?? "none"} medical: ${medical ?? "none"})';
  }
}
