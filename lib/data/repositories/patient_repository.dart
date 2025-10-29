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
  
  List<Patient> getAll() {
    return dataSource.patients;
  }

  List<Patient> search(String query) {
    final lowerCaseQuery = query.toLowerCase();
    return dataSource.patients
        .where((p) =>
            p.id.toLowerCase().contains(lowerCaseQuery) ||
            p.name.toLowerCase().contains(lowerCaseQuery) ||
            p.contact.contains(query))
        .toList();
  }

  void update(Patient p) {
    dataSource.updatePatient(p);
  }
}