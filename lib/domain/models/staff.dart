enum Role { receptionist, doctor, admin }

class Staff {
  String id;
  String name;
  Role role;
  String availability; // Mon-Fri 9am-5pm
  String password;

  Staff({
    required this.id,
    required this.name,
    required this.role,
    this.availability = 'Not set',
    required this.password
  });
  @override
  String toString() {
    return 'ID: $id, Name: $name, Role: $role, Availability: $availability';
  }
}
