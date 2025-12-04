import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController(text: '');
  final _passController = TextEditingController(text: '');
  bool _loading = false;

  void _login() async {
    final u = _userController.text.trim();
    final p = _passController.text;
    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return; // simulate
    setState(() => _loading = false);

    // Dummy auth
    if (u == 'guru' && p == '1234') {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (u == 'admin' && p == '1234') {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username atau password salah')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: w > 600 ? 540 : double.infinity,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Text('SELAMAT DATANG!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _userController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0), // ganti warna disini
                          foregroundColor: Colors.white, // warna teks/icon
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const CircularProgressIndicator.adaptive()
                            : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),

                    ),
                    const SizedBox(height: 8),
                    const Text('Guru: guru / 1234', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('Admin: admin / 1234', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
