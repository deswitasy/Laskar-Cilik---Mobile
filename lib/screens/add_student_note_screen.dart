import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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
  List<String> _fileDokumen = [];
  List<String> _fileFoto = [];
  List<String> _fotoKeterangan = [];

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
      _fileDokumen = List.from(widget.note!.fileDokumen);
      _fileFoto = List.from(widget.note!.fileFoto);
      _fotoKeterangan = List.from(widget.note!.fotoKeterangan);
      // Ensure keterangan list matches foto list length
      while (_fotoKeterangan.length < _fileFoto.length) {
        _fotoKeterangan.add('');
      }
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
      fileDokumen: _fileDokumen,
      fileFoto: _fileFoto,
      fotoKeterangan: _fotoKeterangan,
    );

    Navigator.pop(context, newNote);
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx', 'xls', 'txt'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileDokumen.add(result.files.first.name);
      });
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _fileFoto.add(image.path);
        _fotoKeterangan.add(''); // Add empty keterangan
      });
    }
  }

  void _removeDocument(int index) {
    setState(() => _fileDokumen.removeAt(index));
  }

  void _removePhoto(int index) {
    setState(() {
      _fileFoto.removeAt(index);
      if (index < _fotoKeterangan.length) {
        _fotoKeterangan.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Predikat Siswa' : 'Tambah Catatan Siswa'),
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
              'Predikat Perkembangan Siswa',
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
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Lampiran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Dokumen Section
            const Text(
              'Dokumen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDocument,
                    icon: const Icon(Icons.file_present),
                    label: const Text('Pilih Dokumen'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_fileDokumen.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _fileDokumen.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _fileDokumen[idx],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            iconSize: 18,
                            onPressed: () => _removeDocument(idx),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 12),
            // Foto Section
            const Text(
              'Foto/Gambar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickPhoto,
                    icon: const Icon(Icons.image),
                    label: const Text('Pilih Foto'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_fileFoto.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _fileFoto.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.image, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _fileFoto[idx].split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                iconSize: 18,
                                onPressed: () => _removePhoto(idx),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            onChanged: (value) {
                              _fotoKeterangan[idx] = value;
                            },
                            initialValue: _fotoKeterangan[idx],
                            decoration: InputDecoration(
                              hintText: 'Masukkan keterangan foto...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              isDense: true,
                            ),
                            maxLines: 2,
                            minLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
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
            labelText: 'Predikat',
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
