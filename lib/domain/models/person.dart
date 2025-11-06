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
  
  @override
  String toString() => 'ID: $id, Name: $name';
}
