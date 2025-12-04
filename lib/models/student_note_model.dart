class StudentNote {
  final String id;
  final String studentId;
  final String studentName;
  final String nilaiAgama;
  final String deskripsiAgama;
  final String nilaiJatiDiri;
  final String deskripsiJatiDiri;
  final String nilaiSTEM;
  final String deskripsiSTEM;
  final String nilaiPancasila;
  final String deskripsiPancasila;
  final DateTime createdAt;

  StudentNote({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.nilaiAgama,
    required this.deskripsiAgama,
    required this.nilaiJatiDiri,
    required this.deskripsiJatiDiri,
    required this.nilaiSTEM,
    required this.deskripsiSTEM,
    required this.nilaiPancasila,
    required this.deskripsiPancasila,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  StudentNote copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? nilaiAgama,
    String? deskripsiAgama,
    String? nilaiJatiDiri,
    String? deskripsiJatiDiri,
    String? nilaiSTEM,
    String? deskripsiSTEM,
    String? nilaiPancasila,
    String? deskripsiPancasila,
    DateTime? createdAt,
  }) {
    return StudentNote(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      nilaiAgama: nilaiAgama ?? this.nilaiAgama,
      deskripsiAgama: deskripsiAgama ?? this.deskripsiAgama,
      nilaiJatiDiri: nilaiJatiDiri ?? this.nilaiJatiDiri,
      deskripsiJatiDiri: deskripsiJatiDiri ?? this.deskripsiJatiDiri,
      nilaiSTEM: nilaiSTEM ?? this.nilaiSTEM,
      deskripsiSTEM: deskripsiSTEM ?? this.deskripsiSTEM,
      nilaiPancasila: nilaiPancasila ?? this.nilaiPancasila,
      deskripsiPancasila: deskripsiPancasila ?? this.deskripsiPancasila,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'StudentNote(id: $id, studentId: $studentId, studentName: $studentName)';
}
