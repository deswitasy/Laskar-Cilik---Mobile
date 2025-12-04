class StudentData {
  final String id;
  final String nama;
  final String kelas;
  final int semester;
  final String tahunAjaran;
  final DateTime createdAt;

  StudentData({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.semester,
    required this.tahunAjaran,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  StudentData copyWith({
    String? id,
    String? nama,
    String? kelas,
    int? semester,
    String? tahunAjaran,
    DateTime? createdAt,
  }) {
    return StudentData(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'StudentData(id: $id, nama: $nama, kelas: $kelas, semester: $semester, tahunAjaran: $tahunAjaran)';
}
