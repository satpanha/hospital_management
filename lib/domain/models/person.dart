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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dob': dob.toIso8601String(),
      'contact': contact,
      'address': address,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      dob: DateTime.parse(json['dob']),
      contact: json['contact'],
      address: json['address'],
    );
  }

  void validate() {
    if(!contact.contains('@') && !RegExp(r'^\d{10,}$').hasMatch(contact)) throw ArgumentError('Invalid contact format');
    if (id.isEmpty) throw ArgumentError('Person ID cannot be empty');
    if (name.isEmpty) throw ArgumentError('Person name cannot be empty');
    if (contact.isEmpty) throw ArgumentError('Person contact cannot be empty');
    if (address.isEmpty) throw ArgumentError('Person address cannot be empty');
    if (dob.isAfter(DateTime.now())) throw ArgumentError('Date of birth cannot be in the future');
  }
  
  @override
  String toString() => 'ID: $id, Name: $name';
}
