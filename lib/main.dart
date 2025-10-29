import 'data/datasources/in_memory_data_source.dart';
import 'data/repositories/appointment_repository.dart';
import 'data/repositories/patient_repository.dart';
import 'data/repositories/staff_repository.dart';
import 'domain/services/appointment_service.dart';
import 'domain/services/patient_service.dart';
import 'domain/services/staff_service.dart';
import 'ui/menu.dart';

void main() {
  // --- Dependency Injection Setup ---

  // 1. Data Layer
  final dataSource = InMemoryDataSource();
  final patientRepository = PatientRepository(dataSource);
  final staffRepository = StaffRepository(dataSource);
  final appointmentRepository = AppointmentRepository(dataSource);

  // 2. Domain Layer
  final patientService = PatientService(patientRepository, appointmentRepository);
  final staffService = StaffService(staffRepository);
  final appointmentService = AppointmentService(appointmentRepository, staffRepository);

  // 3. UI Layer
  final menu = Menu(
    patientService: patientService,
    staffService: staffService,
    appointmentService: appointmentService,
  );

  // --- Start Application ---
  print('Initializing Hospital Management System...');
  menu.displayMainMenu();
  print('Exiting System. Goodbye!');
}