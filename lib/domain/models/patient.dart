class Patient {
  final String id;
  final String name;
  final DateTime dob;
  final String contact;
  final String address;
  List<String> medicalList = [];

  Patient({
    required this.id,
    required this.name,
    required this.dob,
    required this.contact,
    required this.address,
  });

  @override
  String toString() {
    return 'ID: $id, Name: $name, Contact: $contact, Address: $address';
  }

  String get medicalSummary {
    return medicalList.isEmpty ? 'No Medical History' : medicalList.join('\n');
  }
}
