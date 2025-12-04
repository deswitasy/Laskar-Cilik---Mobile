import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/student_data_model.dart';
import '../models/student_note_model.dart';
import '../widgets/student_note_card.dart';
import 'add_student_note_screen.dart';
import 'student_note_detail_screen.dart';
import 'progress_chart_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<StudentData> availableStudents = [];
  List<StudentNote> notes = [];
  List<StudentNote> filteredNotes = [];
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Data siswa yang tersedia (dari admin)
    availableStudents = [
      StudentData(
        id: 's0',
        nama: 'Deswita',
        kelas: 'A',
        semester: 1,
        tahunAjaran: '2024/2025',
      ),
      StudentData(
        id: 's1',
        nama: 'Apriliani',
        kelas: 'A',
        semester: 1,
        tahunAjaran: '2024/2025',
      ),
      StudentData(
        id: 's2',
        nama: 'Aisyah',
        kelas: 'B',
        semester: 1,
        tahunAjaran: '2024/2025',
      ),
      StudentData(
        id: 's3',
        nama: 'Nadya',
        kelas: 'B',
        semester: 1,
        tahunAjaran: '2024/2025',
      ),
    ];

    // Catatan siswa (bisa kosong di awal)
    notes = [];
    filteredNotes = List.from(notes);
  }

  void _onSearch(String q) {
    final s = q.toLowerCase();
    setState(() {
      if (s.isEmpty) {
        filteredNotes = List.from(notes);
      } else {
        filteredNotes = notes
            .where((note) => note.studentName.toLowerCase().contains(s))
            .toList();
      }
    });
  }

  Future<void> _goToAdd() async {
    final result = await Navigator.push<StudentNote?>(
      context,
      MaterialPageRoute(
        builder: (_) => AddStudentNoteScreen(
          availableStudents: availableStudents,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        notes.insert(0, result);
        filteredNotes = List.from(notes);
      });
    }
  }

  Future<void> _editNote(StudentNote note, int index) async {
    final result = await Navigator.push<StudentNote?>(
      context,
      MaterialPageRoute(
        builder: (_) => AddStudentNoteScreen(
          availableStudents: availableStudents,
          note: note,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        notes[index] = result;
        filteredNotes = List.from(notes);
      });
    }
  }

  void _removeNote(int index) {
    final removed = notes.removeAt(index);
    setState(() {
      filteredNotes = List.from(notes);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan terhapus: ${removed.studentName}')));
  }

  void _openDetail(StudentNote note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentNoteDetailScreen(note: note),
      ),
    );
  }

  // fungsi logout
  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // tutup dialog
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dt = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Perkembangan Siswa'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProgressChartScreen(notes: notes),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Grafik Perkembangan',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _onSearch,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cari nama siswa...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _goToAdd,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Tambah',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text('Jumlah: ${filteredNotes.length}'),
                const Spacer(),
                Text(
                  'Tanggal: $dt',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text('Tidak ada catatan'))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, idx) {
                      final note = filteredNotes[idx];
                      final origIndex = notes.indexWhere(
                        (e) => e.id == note.id,
                      );
                      return StudentNoteCard(
                        note: note,
                        onDetail: () => _openDetail(note),
                        onEdit: () =>
                            _editNote(note, origIndex < 0 ? idx : origIndex),
                        onDelete: () =>
                            _confirmDelete(origIndex < 0 ? idx : origIndex),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerRed,
            ),
            onPressed: () {
              _removeNote(index);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
