import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/teacher_model.dart';
import '../models/student_data_model.dart';
import '../widgets/teacher_card.dart';
import '../widgets/student_data_card.dart';
import 'add_teacher_screen.dart';
import 'add_student_data_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Teacher> teachers = [];
  List<Teacher> filteredTeachers = [];
  List<StudentData> students = [];
  List<StudentData> filteredStudents = [];
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeDummyData();
  }

  void _initializeDummyData() {
    // Dummy teacher data
    teachers = List.generate(3, (i) {
      return Teacher(
        id: 't$i',
        nama: ['Ibu Siti', 'Pak Budi', 'Ibu Maya'][i],
        email: ['siti@example.com', 'budi@example.com', 'maya@example.com'][i],
        noTelepon: ['081234567890', '081234567891', '081234567892'][i],
        kelasDiajar: ['A', 'B', 'C'][i],
        status: 'Aktif',
      );
    });
    filteredTeachers = List.from(teachers);

    // Dummy student data (hanya data dasar)
    students = List.generate(4, (i) {
      return StudentData(
        id: 's$i',
        nama: ['Deswita', 'Apriliani', 'Aisyah', 'Nadya'][i],
        kelas: ['A', 'A', 'B', 'B'][i],
        semester: 1,
        tahunAjaran: '2024/2025',
      );
    });
    filteredStudents = List.from(students);
  }

  void _onSearch(String q) {
    final s = q.toLowerCase();
    setState(() {
      if (_tabController.index == 0) {
        // Teacher tab
        if (s.isEmpty) {
          filteredTeachers = List.from(teachers);
        } else {
          filteredTeachers = teachers
              .where((t) =>
                  t.nama.toLowerCase().contains(s) ||
                  t.kelasDiajar.toLowerCase().contains(s))
              .toList();
        }
      } else {
        // Student tab
        if (s.isEmpty) {
          filteredStudents = List.from(students);
        } else {
          filteredStudents = students
              .where((st) => st.nama.toLowerCase().contains(s))
              .toList();
        }
      }
    });
  }

  Future<void> _goToAddTeacher() async {
    final result = await Navigator.push<Teacher?>(
      context,
      MaterialPageRoute(builder: (_) => const AddTeacherScreen()),
    );
    if (result != null) {
      setState(() {
        teachers.insert(0, result);
        filteredTeachers = List.from(teachers);
        _searchCtrl.clear();
      });
    }
  }

  Future<void> _editTeacher(Teacher t, int index) async {
    final result = await Navigator.push<Teacher?>(
      context,
      MaterialPageRoute(builder: (_) => AddTeacherScreen(teacher: t)),
    );
    if (result != null) {
      setState(() {
        teachers[index] = result;
        filteredTeachers = List.from(teachers);
      });
    }
  }

  void _removeTeacher(int index) {
    final removed = teachers.removeAt(index);
    setState(() {
      filteredTeachers = List.from(teachers);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guru terhapus: ${removed.nama}')));
  }

  Future<void> _goToAddStudent() async {
    final result = await Navigator.push<StudentData?>(
      context,
      MaterialPageRoute(builder: (_) => const AddStudentDataScreen()),
    );
    if (result != null) {
      setState(() {
        students.insert(0, result);
        filteredStudents = List.from(students);
        _searchCtrl.clear();
      });
    }
  }

  Future<void> _editStudent(StudentData s, int index) async {
    final result = await Navigator.push<StudentData?>(
      context,
      MaterialPageRoute(builder: (_) => AddStudentDataScreen(studentData: s)),
    );
    if (result != null) {
      setState(() {
        students[index] = result;
        filteredStudents = List.from(students);
      });
    }
  }

  void _removeStudent(int index) {
    final removed = students.removeAt(index);
    setState(() {
      filteredStudents = List.from(students);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Siswa terhapus: ${removed.nama}')));
  }

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
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTeacher(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Yakin ingin menghapus data guru ini?'),
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
              _removeTeacher(index);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteStudent(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Yakin ingin menghapus data siswa ini?'),
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
              _removeStudent(index);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
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
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) {
            _searchCtrl.clear();
            setState(() {});
          },
          tabs: const [
            Tab(text: 'Data Guru', icon: Icon(Icons.person)),
            Tab(text: 'Data Siswa', icon: Icon(Icons.people)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Teacher Tab
          Column(
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
                          hintText: 'Cari nama guru...',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _goToAddTeacher,
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
                    Text('Jumlah: ${filteredTeachers.length}'),
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
                child: filteredTeachers.isEmpty
                    ? const Center(child: Text('Tidak ada data guru'))
                    : ListView.builder(
                        itemCount: filteredTeachers.length,
                        itemBuilder: (context, idx) {
                          final t = filteredTeachers[idx];
                          final origIndex = teachers.indexWhere(
                            (e) => e.id == t.id,
                          );
                          return TeacherCard(
                            teacher: t,
                            onEdit: () =>
                                _editTeacher(t, origIndex < 0 ? idx : origIndex),
                            onDelete: () => _confirmDeleteTeacher(
                                origIndex < 0 ? idx : origIndex),
                          );
                        },
                      ),
              ),
            ],
          ),
          // Student Tab
          Column(
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
                      onPressed: _goToAddStudent,
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
                    Text('Jumlah: ${filteredStudents.length}'),
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
                child: filteredStudents.isEmpty
                    ? const Center(child: Text('Tidak ada data siswa'))
                    : ListView.builder(
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, idx) {
                          final s = filteredStudents[idx];
                          final origIndex = students.indexWhere(
                            (e) => e.id == s.id,
                          );
                          return StudentDataCard(
                            student: s,
                            onEdit: () =>
                                _editStudent(s, origIndex < 0 ? idx : origIndex),
                            onDelete: () => _confirmDeleteStudent(
                                origIndex < 0 ? idx : origIndex),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }
}
