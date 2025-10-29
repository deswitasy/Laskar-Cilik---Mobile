class Student {
  final String id;
  final String nama;
  final String kelas;
  final int semester;
  final String tahunAjaran;
  final String nilaiAjaran;
  final String deskripsiAjaran;
  final String nilaiJatiDiri;
  final String deskripsiJatiDiri;
  final String nilaiSTEM;
  final String deskripsiSTEM;
  final String nilaiManasik;
  final String deskripsiManasik;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.semester,
    required this.tahunAjaran,
    required this.nilaiAjaran,
    required this.deskripsiAjaran,
    required this.nilaiJatiDiri,
    required this.deskripsiJatiDiri,
    required this.nilaiSTEM,
    required this.deskripsiSTEM,
    required this.nilaiManasik,
    required this.deskripsiManasik,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Student copyWith({
    String? id,
    String? nama,
    String? kelas,
    int? semester,
    String? tahunAjaran,
    String? nilaiAjaran,
    String? deskripsiAjaran,
    String? nilaiJatiDiri,
    String? deskripsiJatiDiri,
    String? nilaiSTEM,
    String? deskripsiSTEM,
    String? nilaiManasik,
    String? deskripsiManasik,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      nilaiAjaran: nilaiAjaran ?? this.nilaiAjaran,
      deskripsiAjaran: deskripsiAjaran ?? this.deskripsiAjaran,
      nilaiJatiDiri: nilaiJatiDiri ?? this.nilaiJatiDiri,
      deskripsiJatiDiri: deskripsiJatiDiri ?? this.deskripsiJatiDiri,
      nilaiSTEM: nilaiSTEM ?? this.nilaiSTEM,
      deskripsiSTEM: deskripsiSTEM ?? this.deskripsiSTEM,
      nilaiManasik: nilaiManasik ?? this.nilaiManasik,
      deskripsiManasik: deskripsiManasik ?? this.deskripsiManasik,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
