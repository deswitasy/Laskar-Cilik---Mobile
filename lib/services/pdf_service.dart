import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/student_model.dart';
import 'package:pdf/pdf.dart';

class PdfService {
  static Future<Uint8List> generateStudentListPdf(List<Student> students) async {
    final pdf = pw.Document();
    final dateNow = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Text('Daftar Catatan Perkembangan Siswa', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Text('Dicetak: $dateNow', style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['No', 'Nama', 'Kelas', 'Semester', 'Tahun', 'Nilai Ajaran'],
              data: List.generate(students.length, (index) {
                final s = students[index];
                return [
                  (index + 1).toString(),
                  s.nama,
                  s.kelas,
                  s.semester.toString(),
                  s.tahunAjaran,
                  s.nilaiAjaran,
                ];
              }),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printStudentList(List<Student> students) async {
    final bytes = await generateStudentListPdf(students);
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  static Future<Uint8List> generateStudentDetailPdf(Student s) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Detail Perkembangan', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Nama: ${s.nama}'),
              pw.Text('Kelas: ${s.kelas}'),
              pw.Text('Semester: ${s.semester}'),
              pw.Text('Tahun Ajaran: ${s.tahunAjaran}'),
              pw.SizedBox(height: 8),
              pw.Text('Nilai Ajaran: ${s.nilaiAjaran}'),
              pw.Text('Deskripsi: ${s.deskripsiAjaran}'),
              pw.SizedBox(height: 6),
              pw.Text('Nilai STEM: ${s.nilaiSTEM}'),
              pw.Text('Deskripsi: ${s.deskripsiSTEM}'),
              pw.SizedBox(height: 6),
              pw.Text('Nilai Manasik: ${s.nilaiManasik}'),
              pw.Text('Deskripsi: ${s.deskripsiManasik}'),
              pw.SizedBox(height: 6),
              pw.Text('Nilai Jati Diri: ${s.nilaiJatiDiri}'),
              pw.Text('Deskripsi: ${s.deskripsiJatiDiri}'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printStudentDetail(Student s) async {
    final bytes = await generateStudentDetailPdf(s);
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }
}
