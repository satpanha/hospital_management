class Person {
  final String id;
  String name;
  DateTime dob;
  String contact;
  String address;

  Person({
    required this.id,
    required this.name,
    required this.dob,
    required this.contact,
    required this.address,
  });

  @override
  String toString() => 'ID: $id, Name: $name';
}
