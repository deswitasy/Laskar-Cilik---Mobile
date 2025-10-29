import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentCard({
    super.key,
    required this.student,
    required this.onDetail,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          student.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Kelas ${student.kelas} | Semester ${student.semester}\n'
          'Nilai Ajaran: ${student.nilaiAjaran}',
        ),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.green),
              tooltip: 'Detail',
              onPressed: onDetail,
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Hapus',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
