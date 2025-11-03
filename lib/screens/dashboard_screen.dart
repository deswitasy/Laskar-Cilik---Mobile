import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/student_model.dart';
import '../widgets/student_card.dart';
import 'add_student_screen.dart';
import 'student_detail_screen.dart';
import '../services/pdf_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Student> students = [];
  List<Student> filtered = [];
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // dummy sample data
    students = List.generate(4, (i) {
      return Student(
        id: 's$i',
        nama: ['Deswita', 'Apriliani', 'Aisyah', 'Nadya'][i],
        kelas: ['A', 'A', 'B', 'B'][i],
        semester: 1,
        tahunAjaran: '2024/2025',
        nilaiAgama: 'Baik',
        deskripsiAgama: 'Perkembangan baik.',
        nilaiJatiDiri: 'Baik',
        deskripsiJatiDiri: 'Sopan dan tanggung jawab.',
        nilaiSTEM: 'Baik',
        deskripsiSTEM: 'Terampil di sains.',
        nilaiPancasila: 'Cukup',
        deskripsiPancasila: 'Perlu perbaikan.',
      );
    });
    filtered = List.from(students);
  }

  void _onSearch(String q) {
    final s = q.toLowerCase();
    setState(() {
      if (s.isEmpty) {
        filtered = List.from(students);
      } else {
        filtered = students
            .where((st) => st.nama.toLowerCase().contains(s))
            .toList();
      }
    });
  }

  Future<void> _goToAdd() async {
    final result = await Navigator.push<Student?>(
      context,
      MaterialPageRoute(builder: (_) => const AddStudentScreen()),
    );
    if (result != null) {
      setState(() {
        students.insert(0, result);
        filtered = List.from(students);
      });
    }
  }

  Future<void> _editStudent(Student s, int index) async {
    final result = await Navigator.push<Student?>(
      context,
      MaterialPageRoute(builder: (_) => AddStudentScreen(student: s)),
    );
    if (result != null) {
      setState(() {
        students[index] = result;
        filtered = List.from(students);
      });
    }
  }

  void _removeStudent(int index) {
    final removed = students.removeAt(index);
    setState(() {
      filtered = List.from(students);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Terhapus: ${removed.nama}')));
  }

  void _printAll() async {
    await PdfService.printStudentList(students);
  }

  void _openDetail(Student s) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StudentDetailScreen(student: s)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dt = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Perkembangan Siswa'),
        actions: [
          IconButton(onPressed: _printAll, icon: const Icon(Icons.print)),
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
                Text('Jumlah: ${filtered.length}'),
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
            child: filtered.isEmpty
                ? const Center(child: Text('Tidak ada data'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final s = filtered[idx];
                      final origIndex = students.indexWhere(
                        (e) => e.id == s.id,
                      );
                      return StudentCard(
                        student: s,
                        onDetail: () => _openDetail(s),
                        onEdit: () =>
                            _editStudent(s, origIndex < 0 ? idx : origIndex),
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
        content: const Text('Yakin ingin menghapus data Catatan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _removeStudent(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerRed,
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
