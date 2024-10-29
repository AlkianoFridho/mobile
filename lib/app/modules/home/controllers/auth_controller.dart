import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences
import 'package:mobile/app/modules/home/views/login_page.dart'; // Ensure you import the correct login page
import 'package:mobile/app/modules/home/views/home_view.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final SharedPreferences _prefs; // Use late initialization
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus(); // Check login status when the controller is initialized
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance(); // Initialize Shared Preferences
  }

  Future<void> checkLoginStatus() async {
    await initPrefs(); // Ensure preferences are initialized
    isLoggedIn.value = _prefs.containsKey('user_token'); // Check if token exists
  }

  // Function for user registration
  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.snackbar(
        'Success',
        'Registration successful',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.off(() => LoginPage());
      
    } catch (error) {
      Get.snackbar(
        'Error',
        'Registration failed: ${error.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Function for user login
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store the user token in Shared Preferences
      await _prefs.setString('user_token', _auth.currentUser!.uid); // Save user token
      isLoggedIn.value = true; // Set login status to true

      Get.snackbar(
        'Success',
        'Login successful',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => HomeView()); // Navigate to Home and remove previous pages
      
    } catch (error) {
      Get.snackbar(
        'Error',
        'Login failed: ${error.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Function for user logout
  void logout() async {
    await _auth.signOut();
    await _prefs.remove('user_token'); // Remove user token on logout
    isLoggedIn.value = false; // Set login status to false
    Get.offAll(() => LoginPage()); // Navigate to Login page
  }
}
