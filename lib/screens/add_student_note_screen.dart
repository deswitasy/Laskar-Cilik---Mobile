import 'package:flutter/material.dart';
import '../models/student_data_model.dart';
import '../models/student_note_model.dart';
import '../core/theme.dart';

class AddStudentNoteScreen extends StatefulWidget {
  final List<StudentData> availableStudents;
  final StudentNote? note;

  const AddStudentNoteScreen({
    super.key,
    required this.availableStudents,
    this.note,
  });

  @override
  State<AddStudentNoteScreen> createState() => _AddStudentNoteScreenState();
}

class _AddStudentNoteScreenState extends State<AddStudentNoteScreen> {
  late String _selectedStudentId;
  late String _selectedStudentName;
  String _nilaiAgama = 'Baik';
  final _descAgama = TextEditingController();
  String _nilaiJatiDiri = 'Baik';
  final _descJatiDiri = TextEditingController();
  String _nilaiSTEM = 'Baik';
  final _descSTEM = TextEditingController();
  String _nilaiPancasila = 'Baik';
  final _descPancasila = TextEditingController();
  final _opsiNilai = ['Sangat Baik', 'Baik', 'Cukup', 'Kurang'];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _selectedStudentId = widget.note!.studentId;
      _selectedStudentName = widget.note!.studentName;
      _nilaiAgama = widget.note!.nilaiAgama;
      _descAgama.text = widget.note!.deskripsiAgama;
      _nilaiJatiDiri = widget.note!.nilaiJatiDiri;
      _descJatiDiri.text = widget.note!.deskripsiJatiDiri;
      _nilaiSTEM = widget.note!.nilaiSTEM;
      _descSTEM.text = widget.note!.deskripsiSTEM;
      _nilaiPancasila = widget.note!.nilaiPancasila;
      _descPancasila.text = widget.note!.deskripsiPancasila;
    } else {
      if (widget.availableStudents.isNotEmpty) {
        _selectedStudentId = widget.availableStudents[0].id;
        _selectedStudentName = widget.availableStudents[0].nama;
      } else {
        _selectedStudentId = '';
        _selectedStudentName = '';
      }
    }
  }

  void _save() {
    if (_selectedStudentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih siswa terlebih dahulu')),
      );
      return;
    }

    final newNote = StudentNote(
      id: widget.note?.id ?? 'note${DateTime.now().millisecondsSinceEpoch}',
      studentId: _selectedStudentId,
      studentName: _selectedStudentName,
      nilaiAgama: _nilaiAgama,
      deskripsiAgama: _descAgama.text.trim(),
      nilaiJatiDiri: _nilaiJatiDiri,
      deskripsiJatiDiri: _descJatiDiri.text.trim(),
      nilaiSTEM: _nilaiSTEM,
      deskripsiSTEM: _descSTEM.text.trim(),
      nilaiPancasila: _nilaiPancasila,
      deskripsiPancasila: _descPancasila.text.trim(),
    );

    Navigator.pop(context, newNote);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan Siswa' : 'Tambah Catatan Siswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedStudentId.isEmpty ? null : _selectedStudentId,
              decoration: const InputDecoration(
                labelText: 'Pilih Siswa',
                hintText: 'Pilih siswa untuk membuat catatan',
              ),
              items: widget.availableStudents
                  .map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text('${s.nama} (${s.kelas})'),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  final student = widget.availableStudents.firstWhere((s) => s.id == val);
                  setState(() {
                    _selectedStudentId = val;
                    _selectedStudentName = student.nama;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Penilaian',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildValueSection(
              title: 'Agama',
              nilai: _nilaiAgama,
              onNilaiChanged: (val) => setState(() => _nilaiAgama = val),
              desc: _descAgama,
            ),
            const SizedBox(height: 16),
            _buildValueSection(
              title: 'Jati Diri',
              nilai: _nilaiJatiDiri,
              onNilaiChanged: (val) => setState(() => _nilaiJatiDiri = val),
              desc: _descJatiDiri,
            ),
            const SizedBox(height: 16),
            _buildValueSection(
              title: 'STEM',
              nilai: _nilaiSTEM,
              onNilaiChanged: (val) => setState(() => _nilaiSTEM = val),
              desc: _descSTEM,
            ),
            const SizedBox(height: 16),
            _buildValueSection(
              title: 'Pancasila',
              nilai: _nilaiPancasila,
              onNilaiChanged: (val) => setState(() => _nilaiPancasila = val),
              desc: _descPancasila,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppTheme.primaryBlue,
                ),
                onPressed: _save,
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueSection({
    required String title,
    required String nilai,
    required Function(String) onNilaiChanged,
    required TextEditingController desc,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: nilai,
          decoration: const InputDecoration(
            labelText: 'Nilai',
            isDense: true,
          ),
          items: _opsiNilai
              .map((n) => DropdownMenuItem(value: n, child: Text(n)))
              .toList(),
          onChanged: (val) {
            if (val != null) onNilaiChanged(val);
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: desc,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Deskripsi',
            hintText: 'Masukkan deskripsi perkembangan',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descAgama.dispose();
    _descJatiDiri.dispose();
    _descSTEM.dispose();
    _descPancasila.dispose();
    super.dispose();
  }
}
