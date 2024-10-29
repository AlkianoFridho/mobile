import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/home/controllers/auth_controller.dart'; // Pastikan untuk mengimpor AuthController
import 'package:mobile/app/modules/home/views/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key); // Menggunakan const constructor

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress, // Menampilkan keyboard email
              autofillHints: [AutofillHints.email], // Menambahkan autofill
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              autofillHints: [AutofillHints.password], // Menambahkan autofill
            ),
            SizedBox(height: 16),
            Obx(() {
              return ElevatedButton(
                onPressed: _authController.isLoading.value
                    ? null
                    : () {
                        // Validasi input
                        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Email and password cannot be empty',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        _authController.loginUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      },
                child: _authController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white) // Mengubah warna indikator
                    : Text('Login'),
              );
            }),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigasi ke halaman registrasi
                Get.to(() => RegisterPage()); // Ganti dengan nama halaman registrasi yang sesuai
              },
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
