import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/teacher_model.dart';
import '../core/theme.dart';

class AddTeacherScreen extends StatefulWidget {
  final Teacher? teacher;

  const AddTeacherScreen({super.key, this.teacher});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  late TextEditingController _namaCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _noTeleponCtrl;
  late String _kelasDiajar;
  late String _status;
  final List<String> _kelasList = ['A', 'B', 'C', 'D'];
  final List<String> _statusList = ['Aktif', 'Non-Aktif'];

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.teacher?.nama ?? '');
    _emailCtrl = TextEditingController(text: widget.teacher?.email ?? '');
    _noTeleponCtrl =
        TextEditingController(text: widget.teacher?.noTelepon ?? '');
    _kelasDiajar = widget.teacher?.kelasDiajar ?? 'A';
    _status = widget.teacher?.status ?? 'Aktif';
  }

  void _save() {
    final nama = _namaCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final noTelepon = _noTeleponCtrl.text.trim();

    if (nama.isEmpty || email.isEmpty || noTelepon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    final newTeacher = Teacher(
      id: widget.teacher?.id ?? 't${DateTime.now().millisecondsSinceEpoch}',
      nama: nama,
      email: email,
      noTelepon: noTelepon,
      kelasDiajar: _kelasDiajar,
      status: _status,
    );

    Navigator.pop(context, newTeacher);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.teacher != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Data Guru' : 'Tambah Data Guru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Guru',
                hintText: 'Masukkan nama guru',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Masukkan email guru',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noTeleponCtrl,
              decoration: const InputDecoration(
                labelText: 'No. Telepon',
                hintText: 'Masukkan nomor telepon',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kelasDiajar,
              decoration: const InputDecoration(
                labelText: 'Kelas yang Diajar',
              ),
              items: _kelasList
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _kelasDiajar = val);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
              ),
              items: _statusList
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _status = val);
                }
              },
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
    _emailCtrl.dispose();
    _noTeleponCtrl.dispose();
    super.dispose();
  }
}
