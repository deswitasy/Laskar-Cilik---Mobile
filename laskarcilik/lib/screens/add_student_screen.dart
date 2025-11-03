import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student_model.dart';
import 'dart:math';
import 'package:intl/date_symbol_data_local.dart';

class AddStudentScreen extends StatefulWidget {
  final Student? student;

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

  // ubah nilai jadi string biasa (karena pakai dropdown)
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
    initializeDateFormatting('id_ID', null);
    final s = widget.student;
    if (s != null) {
      _nama.text = s.nama;
      _kelas = s.kelas;
      _semester.text = s.semester.toString();
      try {
        _tahun = DateFormat('dd/MM/yyyy').parse(s.tahunAjaran);
      } catch (_) {
        _tahun = DateTime.now();
      }

      _nilaiAgama = s.nilaiAgama.isNotEmpty ? s.nilaiAgama : 'Baik';
      _descAgama.text = s.deskripsiAgama;

      _nilaiJatiDiri = s.nilaiJatiDiri.isNotEmpty ? s.nilaiJatiDiri : 'Baik';
      _descJatiDiri.text = s.deskripsiJatiDiri;

      _nilaiSTEM = s.nilaiSTEM.isNotEmpty ? s.nilaiSTEM : 'Baik';
      _descSTEM.text = s.deskripsiSTEM;

      _nilaiPancasila = s.nilaiPancasila.isNotEmpty ? s.nilaiPancasila : 'Baik';
      _descPancasila.text = s.deskripsiPancasila;
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
      nilaiAgama: _nilaiAgama,
      deskripsiAgama: _descAgama.text.trim(),
      nilaiJatiDiri: _nilaiJatiDiri,
      deskripsiJatiDiri: _descJatiDiri.text.trim(),
      nilaiSTEM: _nilaiSTEM,
      deskripsiSTEM: _descSTEM.text.trim(),
      nilaiPancasila: _nilaiPancasila,
      deskripsiPancasila: _descPancasila.text.trim(),
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
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Isi nama' : null,
              ),
              DropdownButtonFormField<String>(
                initialValue: _kelas,
                decoration: const InputDecoration(labelText: 'Kelas'),
                items: ['A', 'B', 'C']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _kelas = v ?? 'A'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _semester,
                decoration: const InputDecoration(labelText: 'Semester'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tahun Ajaran (pilih tanggal)',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('yyyy').format(_tahun)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Predikat & Deskripsi'),
              const Divider(),

              // Agama
              DropdownButtonFormField<String>(
                initialValue: _nilaiAgama,
                decoration: const InputDecoration(labelText: 'Agama'),
                items: _opsiNilai
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _nilaiAgama = v ?? 'Baik'),
              ),
              TextFormField(
                controller: _descAgama,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // Jati Diri
              DropdownButtonFormField<String>(
                initialValue: _nilaiJatiDiri,
                decoration: const InputDecoration(labelText: 'Jati Diri'),
                items: _opsiNilai
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _nilaiJatiDiri = v ?? 'Baik'),
              ),
              TextFormField(
                controller: _descJatiDiri,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // STEM
              DropdownButtonFormField<String>(
                initialValue: _nilaiSTEM,
                decoration: const InputDecoration(labelText: 'STEM'),
                items: _opsiNilai
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _nilaiSTEM = v ?? 'Baik'),
              ),
              TextFormField(
                controller: _descSTEM,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // Pancasila
              DropdownButtonFormField<String>(
                initialValue: _nilaiPancasila,
                decoration: const InputDecoration(labelText: 'Pancasila'),
                items: _opsiNilai
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _nilaiPancasila = v ?? 'Baik'),
              ),
              TextFormField(
                controller: _descPancasila,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),

              const SizedBox(height: 20),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // warna tombol
                        foregroundColor: Colors.white, // warna teks & icon
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
