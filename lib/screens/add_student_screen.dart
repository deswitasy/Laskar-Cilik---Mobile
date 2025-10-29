import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student_model.dart';
import 'dart:math';
import 'package:intl/date_symbol_data_local.dart';


class AddStudentScreen extends StatefulWidget {
  final Student? student; // kalau ada -> edit

  const AddStudentScreen({super.key, this.student});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nama = TextEditingController();
  String _kelas = 'A';
  final _semester = TextEditingController();
  DateTime _tahun = DateTime.now();

  final _nilaiAjaran = TextEditingController();
  final _descAjaran = TextEditingController();

  final _nilaiJatiDiri = TextEditingController();
  final _descJatiDiri = TextEditingController();

  final _nilaiSTEM = TextEditingController();
  final _descSTEM = TextEditingController();

  final _nilaiManasik = TextEditingController();
  final _descManasik = TextEditingController();

  @override
  void initState() {
    super.initState();
  initializeDateFormatting('id_ID', null);
    final s = widget.student;
    if (s != null) {
      _nama.text = s.nama;
      _kelas = s.kelas;
      _semester.text = s.semester.toString();
      try {
        // parse tahun if it's dd/MM/yyyy saved
        _tahun = DateFormat('dd/MM/yyyy').parse(s.tahunAjaran);
      } catch (_) {
        _tahun = DateTime.now();
      }
      _nilaiAjaran.text = s.nilaiAjaran;
      _descAjaran.text = s.deskripsiAjaran;
      _nilaiJatiDiri.text = s.nilaiJatiDiri;
      _descJatiDiri.text = s.deskripsiJatiDiri;
      _nilaiSTEM.text = s.nilaiSTEM;
      _descSTEM.text = s.deskripsiSTEM;
      _nilaiManasik.text = s.nilaiManasik;
      _descManasik.text = s.deskripsiManasik;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tahun,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _tahun = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.student?.id ?? 's${Random().nextInt(99999)}';
    final st = Student(
      id: id,
      nama: _nama.text.trim(),
      kelas: _kelas,
      semester: int.tryParse(_semester.text) ?? 1,
      tahunAjaran: DateFormat('dd/MM/yyyy').format(_tahun),
      nilaiAjaran: _nilaiAjaran.text.trim(),
      deskripsiAjaran: _descAjaran.text.trim(),
      nilaiJatiDiri: _nilaiJatiDiri.text.trim(),
      deskripsiJatiDiri: _descJatiDiri.text.trim(),
      nilaiSTEM: _nilaiSTEM.text.trim(),
      deskripsiSTEM: _descSTEM.text.trim(),
      nilaiManasik: _nilaiManasik.text.trim(),
      deskripsiManasik: _descManasik.text.trim(),
    );

    Navigator.pop(context, st);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nama,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi nama' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _kelas,
                decoration: const InputDecoration(labelText: 'Kelas'),
                items: ['A', 'B', 'C'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _kelas = v ?? 'A'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _semester,
                decoration: const InputDecoration(labelText: 'Semester'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Isi semester' : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Tahun Ajaran (pilih tanggal)'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(_tahun)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Nilai Ajaran
              TextFormField(
                controller: _nilaiAjaran,
                decoration: const InputDecoration(labelText: 'Predikat Ajaran'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descAjaran,
                decoration: const InputDecoration(labelText: 'Deskripsi Ajaran'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // Jati Diri
              TextFormField(
                controller: _nilaiJatiDiri,
                decoration: const InputDecoration(labelText: 'Predikat Jati Diri'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descJatiDiri,
                decoration: const InputDecoration(labelText: 'Deskripsi Jati Diri'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // STEM
              TextFormField(
                controller: _nilaiSTEM,
                decoration: const InputDecoration(labelText: 'Predikat STEM'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descSTEM,
                decoration: const InputDecoration(labelText: 'Deskripsi STEM'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // Manasik
              TextFormField(
                controller: _nilaiManasik,
                decoration: const InputDecoration(labelText: 'Predikat Manasik'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descManasik,
                decoration: const InputDecoration(labelText: 'Deskripsi Manasik'),
                maxLines: 2,
              ),

              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
