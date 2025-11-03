class Student {
  final String id;
  final String nama;
  final String kelas;
  final int semester;
  final String tahunAjaran;
  final String nilaiAgama;
  final String deskripsiAgama;
  final String nilaiJatiDiri;
  final String deskripsiJatiDiri;
  final String nilaiSTEM;
  final String deskripsiSTEM;
  final String nilaiPancasila;
  final String deskripsiPancasila;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.semester,
    required this.tahunAjaran,
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

  Student copyWith({
    String? id,
    String? nama,
    String? kelas,
    int? semester,
    String? tahunAjaran,
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
    return Student(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      nilaiAgama: nilaiAgama ?? this.deskripsiAgama,
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
}
