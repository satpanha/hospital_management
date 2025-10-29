class Patient {
  final String id;
  final String name;
  final DateTime dob;
  final String contact;
  final String address;
  final String medicalSummary;

  Patient({
    required this.id,
    required this.name,
    required this.dob,
    required this.contact,
    required this.address,
    required this.medicalSummary,
  });
  
  @override
  String toString() {
    return 'ID: $id, Name: $name, Contact: $contact, Address: $address';
  }
}