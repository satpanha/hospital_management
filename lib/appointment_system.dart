class Staff{
  String name;
  String gender;
  String id;
  String phoneNUmber;
  DateTime hireDate;
  DateTime dob;
  String password;
  String role;

  Staff({
    required this.id,
    required this.name,
    required this.gender,
    required this.hireDate,
    required this.dob,
    required this.password,
    required this.role,
    required this.phoneNUmber
  });
}

class Availability {
  String dayOfWeek;
  DateTime startTime;
  DateTime endTime;

  Availability({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}

class Doctor extends Staff{
  String specialty;
  List<Availability> availabilitySchedule = [];

  Doctor({
    required super.id,
    required super.name,
    required super.gender,
    required super.phoneNUmber,
    required super.hireDate,
    required super.dob,
    required super.password,
    required super.role,
    required this.specialty, required String phoneNumber,
  });

  void viewSchedule() {
    print("Doctor $name's Schedule:");
    for (var a in availabilitySchedule) {
      print("${a.dayOfWeek}: ${a.startTime} - ${a.endTime}");
    }
  }

  void acceptAppointment(Appointment appointment) {
    appointment.status = "Accepted";
    print("Doctor $name accepted appointment ${appointment.id}");
  }
}

class Nurse extends Staff {
  String certificate;

  Nurse({
    required super.id,
    required super.name,
    required super.gender,
    required super.hireDate,
    required super.dob,
    required super.password,
    required super.role,
    required this.certificate, 
    required super.phoneNUmber,
  });
}

class Patient {
  String id;
  String name;
  String gender;
  DateTime dob;
  String phoneNumber;
  String address;
  String medicalHistory;

  List<Appointment> appointments = [];

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.dob,
    required this.phoneNumber,
    required this.address,
    required this.medicalHistory,
  });

  void bookAppointment(Doctor doctor, DateTime date, String reason) {
    var appointment = Appointment(
      id: "APT-${DateTime.now().millisecondsSinceEpoch}",
      date: date,
      note: reason,
      status: "Pending",
      patient: this,
      doctor: doctor,
    );
    appointments.add(appointment);
    print("Appointment booked with Dr. ${doctor.name} on $date");
  }

  void viewAppointments() {
    print("Appointments for $name:");
    for (var a in appointments) {
      print("${a.id} - ${a.date} - ${a.status}");
    }
  }

  List<Appointment> getAppointmentHistory() {
    return appointments;
  }
}

class Appointment {
  String id;
  DateTime date;
  String note;
  String status;
  Doctor doctor;
  Patient patient;

  Appointment({
    required this.id,
    required this.date,
    required this.note,
    required this.status,
    required this.doctor,
    required this.patient,
  });

  void book(Patient patient, Doctor doctor, DateTime date) {
    this.patient = patient;
    this.doctor = doctor;
    this.date = date;
    // this.status = "Booked";
    print("Appointment booked with Dr. ${doctor.name} for ${patient.name}");
  }

  void reschedule(DateTime newDate) {
    date = newDate;
    status = "Rescheduled";
    print("Appointment $id rescheduled to $newDate");
  }

  void markCompleted() {
    status = "Completed";
    print("Appointment $id marked as completed");
  }

  void cancel() {
    status = "Cancelled";
    print("Appointment $id has been cancelled");
  }
}

class Meeting {
  String meetingID;
  DateTime dateTime;
  String notes;
  String prescription;

  Meeting({
    required this.meetingID,
    required this.dateTime,
    required this.notes,
    required this.prescription,
  });

  void recordNotes(String newNotes) {
    notes = newNotes;
    print("Notes recorded: $notes");
  }

  void generateSummary() {
    print("Meeting Summary:\nNotes: $notes\nPrescription: $prescription");
  }
}
