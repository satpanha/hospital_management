import '../../domain/models/patient.dart';
import '../datasources/in_memory_data_source.dart';

class PatientRepository {
  final InMemoryDataSource dataSource;

  PatientRepository(this.dataSource);

  void addPatient(Patient p) {
    dataSource.addPatient(p);
  }

  Patient? getById(String id) {
    try {
      return dataSource.patients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Patient? getByPhoneNumber(String contact) {
    try {
      return dataSource.patients.firstWhere((p) => p.contact == contact);
    } catch (e) {
      return null;
    }
  }

  List<Patient> getAll() {
    return dataSource.patients;
  }

  List<Patient> search(String query) {
    final lower = query.toLowerCase();
    return dataSource.patients
        .where(
          (p) =>
              p.name.toLowerCase().contains(lower) ||
              p.contact.toLowerCase().contains(lower) ||
              p.id.toLowerCase().contains(lower),
        )
        .toList();
  }

  void update(Patient p) {
    dataSource.updatePatient(p);
  }
}
