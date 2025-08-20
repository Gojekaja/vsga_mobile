class Employee {
  final String id;
  String name;
  String? photoPath;
  String birthPlace;
  DateTime birthDate;
  int absentCount;

  Employee({
    required this.id,
    required this.name,
    this.photoPath,
    required this.birthPlace,
    required this.birthDate,
    this.absentCount = 0,
  });

  // Method to increment absent count
  void markAbsent() {
    absentCount++;
  }

  // Method to reset absent count
  void resetAbsentCount() {
    absentCount = 0;
  }

  // Create a copy of employee with updated values
  Employee copyWith({
    String? id,
    String? name,
    String? photoPath,
    String? birthPlace,
    DateTime? birthDate,
    int? absentCount,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      absentCount: absentCount ?? this.absentCount,
    );
  }
}
