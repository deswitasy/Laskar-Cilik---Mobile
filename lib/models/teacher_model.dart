class Teacher {
  final String id;
  final String nama;
  final String email;
  final String noTelepon;
  final String kelasDiajar;
  final String status;
  final DateTime createdAt;

  Teacher({
    required this.id,
    required this.nama,
    required this.email,
    required this.noTelepon,
    required this.kelasDiajar,
    required this.status,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Teacher copyWith({
    String? id,
    String? nama,
    String? email,
    String? noTelepon,
    String? kelasDiajar,
    String? status,
    DateTime? createdAt,
  }) {
    return Teacher(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noTelepon: noTelepon ?? this.noTelepon,
      kelasDiajar: kelasDiajar ?? this.kelasDiajar,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'Teacher(id: $id, nama: $nama, email: $email, noTelepon: $noTelepon, kelasDiajar: $kelasDiajar, status: $status)';
}
