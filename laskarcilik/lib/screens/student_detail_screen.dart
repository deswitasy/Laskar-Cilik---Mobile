import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/pdf_service.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;
  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Perkembangan'),
        actions: [
          IconButton(
            onPressed: () => PdfService.printStudentDetail(student),
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Nama', student.nama),
                _row('Kelas', student.kelas),
                _row('Semester', student.semester.toString()),
                _row('Tahun Ajaran', student.tahunAjaran),
                const Divider(),
                _heading('Agama'),
                _row('Prdikat', student.nilaiAgama),
                _row('Deskripsi', student.deskripsiAgama),
                const Divider(),
                _heading('STEM'),
                _row('Prdikat', student.nilaiSTEM),
                _row('Deskripsi', student.deskripsiSTEM),
                const Divider(),
                _heading('Pancasila'),
                _row('Prdikat', student.nilaiPancasila),
                _row('Deskripsi', student.deskripsiPancasila),
                const Divider(),
                _heading('Jati Diri'),
                _row('Prdikat', student.nilaiJatiDiri),
                _row('Deskripsi', student.deskripsiJatiDiri),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String l, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(l, style: const TextStyle(fontWeight: FontWeight.w600))),
          const Text(':'),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  Widget _heading(String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

}
