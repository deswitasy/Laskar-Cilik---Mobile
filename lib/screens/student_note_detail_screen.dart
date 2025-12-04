import 'package:flutter/material.dart';
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
