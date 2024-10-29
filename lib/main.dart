import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences
import 'firebase_options.dart'; // Pastikan Anda telah mengonfigurasi ini

void main() async {
  // Menginisialisasi binding dan Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Menggunakan opsi Firebase untuk platform saat ini
  );

  // Inisialisasi Shared Preferences dan daftarkan dengan GetX
  await Get.putAsync(() async => await SharedPreferences.getInstance());

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL, // Rute awal yang ditentukan di AppPages
      getPages: AppPages.routes, // Mengatur rute dari AppPages
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sesuaikan tema aplikasi Anda
      ),
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
    ),
  );
}
