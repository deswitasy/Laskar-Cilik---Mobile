import 'package:flutter/material.dart';
import 'dart:io';
import '../models/student_note_model.dart';
import '../core/theme.dart';

class StudentNoteDetailScreen extends StatelessWidget {
  final StudentNote note;

  const StudentNoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan ${note.studentName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan info siswa
            Card(
              color: AppTheme.lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primaryBlue,
                      child: Text(
                        note.studentName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.studentName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'ID: ${note.studentId}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Tabel penilaian
            _buildPenilaianTable(context),
            const SizedBox(height: 24),
            // Deskripsi lengkap
            const Text(
              'Deskripsi Perkembangan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDeskripsiSection('Agama', note.deskripsiAgama),
            const SizedBox(height: 12),
            _buildDeskripsiSection('Jati Diri', note.deskripsiJatiDiri),
            const SizedBox(height: 12),
            _buildDeskripsiSection('STEM', note.deskripsiSTEM),
            const SizedBox(height: 12),
            _buildDeskripsiSection('Pancasila', note.deskripsiPancasila),
            const SizedBox(height: 24),
            // Lampiran Section
            if (note.fileDokumen.isNotEmpty || note.fileFoto.isNotEmpty) ...[
              const Text(
                'Lampiran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (note.fileDokumen.isNotEmpty) ...[
                const Text(
                  'Dokumen',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: note.fileDokumen.length,
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.description, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                note.fileDokumen[idx],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
              if (note.fileFoto.isNotEmpty) ...[
                const Text(
                  'Foto/Gambar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: note.fileFoto.length,
                  itemBuilder: (context, idx) {
                    final filePath = note.fileFoto[idx];
                    final file = File(filePath);
                    final fileName = filePath.split('/').last;
                    final fileExists = file.existsSync();
                    final keterangan = idx < note.fotoKeterangan.length 
                        ? note.fotoKeterangan[idx] 
                        : '';

                    return GestureDetector(
                      onTap: () {
                        // Show image in fullscreen
                        showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            child: Container(
                              color: Colors.black,
                              child: Stack(
                                children: [
                                  if (fileExists)
                                    Center(
                                      child: Image.file(
                                        file,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  else
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 100,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Gambar tidak ditemukan',
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(ctx),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade100,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (fileExists)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(
                                        file,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Tidak ada',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                        ),
                                      ),
                                      child: Text(
                                        fileName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (keterangan.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Keterangan:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    keterangan,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPenilaianTable(BuildContext context) {
    final List<Map<String, String>> data = [
      {
        'aspek': 'Agama',
        'nilai': note.nilaiAgama,
      },
      {
        'aspek': 'Jati Diri',
        'nilai': note.nilaiJatiDiri,
      },
      {
        'aspek': 'STEM',
        'nilai': note.nilaiSTEM,
      },
      {
        'aspek': 'Pancasila',
        'nilai': note.nilaiPancasila,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Table(
          border: TableBorder.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1.5),
          },
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    'Aspek Perkembangan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    'Predikat',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            // Data rows
            ...data.map((row) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Text(
                      row['aspek']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getNilaiColor(row['nilai']!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        row['nilai']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _getNilaiTextColor(row['nilai']!),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeskripsiSection(String title, String deskripsi) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: const BoxConstraints(minHeight: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            deskripsi,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getNilaiColor(String nilai) {
    switch (nilai) {
      case 'Sangat Baik':
        return Colors.green.shade100;
      case 'Baik':
        return Colors.blue.shade100;
      case 'Cukup':
        return Colors.amber.shade100;
      case 'Kurang':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getNilaiTextColor(String nilai) {
    switch (nilai) {
      case 'Sangat Baik':
        return Colors.green.shade800;
      case 'Baik':
        return Colors.blue.shade800;
      case 'Cukup':
        return Colors.amber.shade800;
      case 'Kurang':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }
}
