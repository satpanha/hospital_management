import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/patient_repository.dart';
import '../../utils/id_generator.dart';
import '../models/appointment.dart';
import '../models/patient.dart';

class PatientService {
  final PatientRepository patientRepository;
  final AppointmentRepository appointmentRepository;


  PatientService(this.patientRepository, this.appointmentRepository);

  Patient registerPatient(String name, DateTime dob, String contact, String address) {
    final id = IdGenerator.generate();
    final newPatient = Patient(
      id: id,
      name: name,
      dob: dob,
      contact: contact,
      address: address
    );
    patientRepository.addPatient(newPatient);
    return newPatient;
  }

  Patient? getPatientById(String id) {
    return patientRepository.getById(id);
  }

  Patient? getPatientByPhoneNumber(String contact) {
    return patientRepository.getByPhoneNumber(contact);
  }

  List<Patient> searchPatients(String query) {
    return patientRepository.search(query);
  }
  
  List<Patient> getAllPatients() {
    return patientRepository.getAll();
  }

  void updatePatient(Patient patient) {
    patientRepository.update(patient);
  }
  
  List<Appointment> getPatientAppointmentHistory(String patientId) {
    return appointmentRepository.getByPatientId(patientId);
  }
}