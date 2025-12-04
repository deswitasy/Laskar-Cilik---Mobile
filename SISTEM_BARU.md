# Update Sistem Manajemen Data - Dokumentasi

## Perubahan Utama

Sistem telah diubah menjadi **dua peran terpisah dengan alur data yang terstruktur**:

### 1. **Admin Role** - Mengelola Data Master
Admin sekarang hanya mengelola **Data Siswa** (nama, kelas, semester) dan **Data Guru**:

- **Data Guru** (Tab 1):
  - CRUD lengkap untuk akun guru
  - Edit nama, email, no telepon, mata pelajaran, status

- **Data Siswa** (Tab 2):
  - CRUD lengkap untuk data siswa dasar
  - Hanya: Nama, Kelas, Semester
  - **Catatan perkembangan dikelola oleh Guru**

### 2. **Guru Role** - Membuat Catatan Perkembangan
Guru tidak lagi membuat data siswa baru. Guru hanya:

- **Memilih siswa dari Dropdown** yang sudah tersedia (dikelola admin)
- **Membuat catatan perkembangan** untuk siswa yang dipilih
- Setiap catatan berisi: Nilai & Deskripsi untuk:
  - Agama
  - Jati Diri
  - STEM
  - Pancasila

## File yang Dibuat/Dimodifikasi

### File Baru:
1. `lib/models/student_data_model.dart` - Model data siswa dasar (nama, kelas, semester)
2. `lib/models/student_note_model.dart` - Model catatan perkembangan siswa
3. `lib/screens/add_student_data_screen.dart` - Form untuk admin menambah/edit data siswa
4. `lib/screens/add_student_note_screen.dart` - Form untuk guru membuat catatan (dengan dropdown siswa)
5. `lib/screens/student_note_detail_screen.dart` - Detail view catatan guru
6. `lib/widgets/student_data_card.dart` - Card untuk menampilkan data siswa (di admin)
7. `lib/widgets/student_note_card.dart` - Card untuk menampilkan catatan siswa (di guru)

### File yang Dimodifikasi:
1. `lib/screens/admin_dashboard_screen.dart` - Update untuk menggunakan StudentData
2. `lib/screens/dashboard_screen.dart` - Update untuk menggunakan StudentNote dengan dropdown

## Alur Data

```
┌─────────────────────────────────────────────────────────────┐
│                    ADMIN DASHBOARD                          │
├─────────────────────┬───────────────────────────────────────┤
│  Tab: Data Guru     │  Tab: Data Siswa (nama, kelas, semester)
│  - CRUD Guru        │  - CRUD Data Siswa Dasar
│  - Add/Edit/Delete  │  - Add/Edit/Delete
└─────────────────────┴───────────────────────────────────────┘
                                ↓
                    Data Siswa tersimpan di admin
                                ↓
┌─────────────────────────────────────────────────────────────┐
│                    GURU DASHBOARD                           │
├─────────────────────────────────────────────────────────────┤
│  Membuat Catatan Perkembangan:
│  1. Pilih Siswa dari Dropdown (data dari admin)
│  2. Isi nilai & deskripsi (Agama, Jati Diri, STEM, Pancasila)
│  3. Simpan sebagai StudentNote
└─────────────────────────────────────────────────────────────┘
```

## Workflow

### Admin:
```
Login (admin/1234) → Admin Panel
  ├─ Tab Guru: Kelola akun guru (Create/Read/Update/Delete)
  └─ Tab Siswa: Kelola data siswa (Create/Read/Update/Delete)
                  - Input: Nama, Kelas, Semester
```

### Guru:
```
Login (guru/1234) → Guru Dashboard
  ├─ Lihat daftar catatan siswa
  ├─ Tambah Catatan Baru:
  │   1. Pilih siswa dari dropdown (data dari admin)
  │   2. Isi penilaian (Agama, Jati Diri, STEM, Pancasila)
  │   3. Simpan
  ├─ Edit catatan yang sudah dibuat
  └─ Hapus catatan
```

## Keuntungan Sistem Baru

✅ **Data Siswa Terpusat** - Admin mengelola, tidak ada duplikasi data
✅ **Workflow Jelas** - Guru fokus pada catatan, bukan data siswa
✅ **Dropdown Selection** - Guru tidak perlu input ulang data siswa
✅ **Scalable** - Mudah menambah siswa dan guru baru
✅ **Konsistensi** - Satu sumber kebenaran untuk data siswa
