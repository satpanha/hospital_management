class Staff {
  final String id;
  final String name;
  final String role;
  final String department;
  String availability; // Mon-Fri 9am-5pm

  Staff({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    this.availability = 'Not set',
  });
  
  @override
  String toString() {
    return 'ID: $id, Name: $name, Role: $role, Department: $department, Availability: $availability';
  }
}