# Admin Dashboard - Dokumentasi Fitur

## Ringkasan
Admin panel telah berhasil dibuat dengan fitur CRUD untuk Data Guru dan Data Siswa.

## Fitur Admin Dashboard

### 1. **Tab 1: Data Guru**
- ✅ Menampilkan daftar semua guru yang terdaftar
- ✅ Search guru berdasarkan nama atau mata pelajaran
- ✅ Tambah guru baru
- ✅ Edit data guru
- ✅ Hapus data guru
- ✅ Informasi guru: Nama, Email, No. Telepon, Mata Pelajaran, Status

### 2. **Tab 2: Data Siswa**
- ✅ Menampilkan daftar semua siswa yang terdaftar
- ✅ Search siswa berdasarkan nama
- ✅ Tambah siswa baru
- ✅ Edit data siswa
- ✅ Lihat detail siswa
- ✅ Hapus data siswa

## File yang Dibuat/Dimodifikasi

### File Baru:
1. **`lib/models/teacher_model.dart`** - Model data untuk guru
2. **`lib/screens/admin_dashboard_screen.dart`** - Halaman utama admin dengan 2 tab
3. **`lib/screens/add_teacher_screen.dart`** - Halaman tambah/edit guru
4. **`lib/widgets/teacher_card.dart`** - Widget kartu guru

### File yang Dimodifikasi:
1. **`lib/main.dart`** - Menambahkan route `/admin` untuk admin dashboard
2. **`lib/screens/login_screen.dart`** - Menambahkan support login admin (username: admin, password: 1234)

## Cara Login

### Role Guru:
- Username: `guru`
- Password: `1234`
- Tampilan: Dashboard Guru (Data Siswa)

### Role Admin:
- Username: `admin`
- Password: `1234`
- Tampilan: Admin Panel (Data Guru + Data Siswa dengan 2 tab)

## Fitur CRUD yang Tersedia

### Untuk Guru (Teacher):
- **Create**: Tambah guru baru dengan form lengkap
- **Read**: Lihat daftar guru dan search
- **Update**: Edit data guru melalui form
- **Delete**: Hapus guru dengan konfirmasi dialog

### Untuk Siswa (Student):
- **Create**: Tambah siswa baru (sama seperti sebelumnya)
- **Read**: Lihat daftar siswa dan search
- **Update**: Edit data siswa (sama seperti sebelumnya)
- **Delete**: Hapus siswa dengan konfirmasi dialog (sama seperti sebelumnya)

## Design & Layout
- ✅ Menggunakan design yang sama dengan Dashboard Guru
- ✅ Konsistensi warna: `AppTheme.primaryBlue` untuk button dan accent
- ✅ TabBar untuk switching antara Data Guru dan Data Siswa
- ✅ Search functionality di kedua tab
- ✅ Konfirmasi dialog sebelum menghapus data
- ✅ Logout functionality dengan konfirmasi
