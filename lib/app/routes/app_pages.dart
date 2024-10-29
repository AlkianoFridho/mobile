import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import 'package:mobile/app/modules/home/bindings/auth_bindings.dart'; // Pastikan untuk mengimpor binding yang sesuai
import 'package:mobile/app/modules/home/views/register_page.dart'; // Ganti dengan path yang benar untuk halaman Register
import 'package:mobile/app/modules/home/views/login_page.dart'; // Ganti dengan path yang benar untuk halaman Login

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.REGISTER; // Ubah ke halaman registrasi

  static final routes = [
    GetPage(
      name: Routes.REGISTER, // Rute untuk halaman registrasi
      page: () => const RegisterPage(), // Halaman registrasi
      binding: AuthBinding(), // Menggunakan AuthBinding
    ),
    GetPage(
      name: Routes.LOGIN, // Rute untuk halaman login
      page: () => const LoginPage(), // Halaman login
      binding: AuthBinding(), // Menggunakan AuthBinding jika perlu
    ),
    GetPage(
      name: Routes.HOME, // Rute untuk halaman home
      page: () => const HomeView(), // Halaman home
      binding: HomeBinding(), // Menggunakan HomeBinding
    ),
  ];
}
