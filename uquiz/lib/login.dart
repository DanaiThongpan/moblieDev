import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uquiz/controllers.dart'; // เรียกใช้ UQuizController
import 'register.dart'; // เรียกใช้หน้า RegisterPage

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UQuizController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ctrl.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // ปิดการแสดง password
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ctrl.authen(
                  ctrl.emailController.text,
                  ctrl.passwordController.text,
                );
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            // ปุ่มย้อนกลับไปหน้าลงทะเบียน
            TextButton(
              onPressed: () {
                Get.off(() => const RegisterPage()); // ย้ายไปยังหน้า RegisterPage
              },
              child: const Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
