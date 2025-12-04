import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/student_data_model.dart';
import '../core/theme.dart';

class AddStudentDataScreen extends StatefulWidget {
  final StudentData? studentData;

  const AddStudentDataScreen({super.key, this.studentData});

  @override
  State<AddStudentDataScreen> createState() => _AddStudentDataScreenState();
}

class _AddStudentDataScreenState extends State<AddStudentDataScreen> {
  late TextEditingController _namaCtrl;
  late String _kelas;
  late TextEditingController _semesterCtrl;
  late TextEditingController _tahunAjaranCtrl;
  final List<String> _kelasList = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.studentData?.nama ?? '');
    _kelas = widget.studentData?.kelas ?? 'A';
    _semesterCtrl = TextEditingController(text: widget.studentData?.semester.toString() ?? '1');
    _tahunAjaranCtrl = TextEditingController(text: widget.studentData?.tahunAjaran ?? '');
  }

  void _save() {
    final nama = _namaCtrl.text.trim();
    final semester = int.tryParse(_semesterCtrl.text) ?? 1;
    final tahunAjaran = _tahunAjaranCtrl.text.trim();

    if (nama.isEmpty || tahunAjaran.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama siswa dan tahun ajaran harus diisi')),
      );
      return;
    }

    // Validasi format tahun ajaran (YYYY/YYYY)
    final tahunAjaranRegex = RegExp(r'^\d{4}/\d{4}$');
    if (!tahunAjaranRegex.hasMatch(tahunAjaran)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format tahun ajaran harus YYYY/YYYY (contoh: 2025/2026)')),
      );
      return;
    }

    final newStudentData = StudentData(
      id: widget.studentData?.id ?? 'std${DateTime.now().millisecondsSinceEpoch}',
      nama: nama,
      kelas: _kelas,
      semester: semester,
      tahunAjaran: tahunAjaran,
    );

    Navigator.pop(context, newStudentData);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.studentData != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Data Siswa' : 'Tambah Data Siswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Siswa',
                hintText: 'Masukkan nama siswa',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kelas,
              decoration: const InputDecoration(
                labelText: 'Kelas',
              ),
              items: _kelasList
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _kelas = val);
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _semesterCtrl,
              decoration: const InputDecoration(
                labelText: 'Semester',
                hintText: 'Masukkan semester (1-6)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tahunAjaranCtrl,
              decoration: const InputDecoration(
                labelText: 'Tahun Ajaran',
                hintText: 'Contoh: 2025/2026',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                _TahunAjaranFormatter(),
              ],
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

  @override
  void dispose() {
    _namaCtrl.dispose();
    _semesterCtrl.dispose();
    _tahunAjaranCtrl.dispose();
    super.dispose();
  }
}

class _TahunAjaranFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Hanya boleh angka dan slash
    if (!RegExp(r'^[0-9/]*$').hasMatch(text)) {
      return oldValue;
    }

    // Batasi panjang hingga 9 karakter (YYYY/YYYY)
    if (text.length > 9) {
      return oldValue;
    }

    // Auto-insert slash setelah 4 digit pertama
    if (text.length == 4 && !text.contains('/')) {
      return TextEditingValue(
        text: '${text}/',
        selection: const TextSelection.collapsed(offset: 5),
      );
    }

    return newValue;
  }
}