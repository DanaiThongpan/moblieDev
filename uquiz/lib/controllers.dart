import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'members.dart';
import 'shopping.dart';

class UQuizController extends GetxController {
  var membersList = <Map<String, dynamic>>[].obs; // ใช้ในการเก็บข้อมูลสมาชิก
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController(); // สำหรับ username
  final memberPasswordController = TextEditingController(); // สำหรับ password ของสมาชิก

  @override
  void onInit() {
    super.onInit();
    fetchMembers(); // ดึงข้อมูลสมาชิกเมื่อเริ่มต้น
  }

  // ฟังก์ชันการลงทะเบียน
  Future<void> register(String username, String email, String password) async {
    try {
      // บันทึกข้อมูลการลงทะเบียนใน SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('email', email);
      await prefs.setString('password', password);

      Get.snackbar(
        'สำเร็จ', 
        'ลงทะเบียนสำเร็จ! กรุณาล็อกอิน.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAll(() => const LoginPage()); // กลับไปที่หน้า Login หลังจากลงทะเบียนสำเร็จ
    } catch (e) {
      Get.snackbar(
        'ข้อผิดพลาด', 
        'ไม่สามารถลงทะเบียนได้: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ฟังก์ชันการล็อกอิน (ดึงข้อมูลจาก SharedPreferences)
  Future<void> authen(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedEmail = prefs.getString('email');
      String? savedPassword = prefs.getString('password');

      // ตรวจสอบว่าเป็นแอดมินหรือไม่
      if (email == 'admin@ubu.ac.th' && password == 'admin@dssi') {
        Get.snackbar(
          'สำเร็จ',
          'แอดมินเข้าสู่ระบบสำเร็จ',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => const MemberListPage()); // ไปที่หน้าแอดมิน (MemberListPage)
      } 
      // ตรวจสอบผู้ใช้ธรรมดาจากการลงทะเบียน
      else if (email == savedEmail && password == savedPassword) {
        Get.snackbar(
          'สำเร็จ',
          'เข้าสู่ระบบสำเร็จ',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => const Shopping()); // ไปที่หน้า Shopping สำหรับผู้ใช้ธรรมดา
      } 
      // ตรวจสอบผู้ใช้จากหน้า MemberListPage
      else {
        int memberCount = prefs.getInt('member_count') ?? 0;
        bool found = false;
        for (int i = 0; i < memberCount; i++) {
          String? memberEmail = prefs.getString('member_email_$i');
          String? memberPassword = prefs.getString('member_password_$i');

          if (email == memberEmail && password == memberPassword) {
            Get.snackbar(
              'สำเร็จ',
              'เข้าสู่ระบบสำเร็จ',
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.to(() => const Shopping()); // ไปที่หน้า Shopping หลังล็อกอินสำเร็จ
            found = true;
            break;
          }
        }

        if (!found) {
          Get.snackbar(
            'ข้อผิดพลาด',
            'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถล็อกอินได้: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ฟังก์ชันเพิ่มสมาชิกใหม่ใน SharedPreferences พร้อมบันทึก password
  Future<void> addMember(String username, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int memberCount = prefs.getInt('member_count') ?? 0;

      // เก็บข้อมูลสมาชิกใหม่ใน SharedPreferences
      await prefs.setString('member_username_$memberCount', username);
      await prefs.setString('member_email_$memberCount', email);
      await prefs.setString('member_password_$memberCount', password); // เก็บ password
      await prefs.setInt('member_count', memberCount + 1);

      // อัปเดตรายการสมาชิกใหม่ใน Observable List
      membersList.add({'username': username, 'email': email, 'password': password});

      Get.snackbar(
        'สำเร็จ', 
        'สมาชิกถูกเพิ่มเรียบร้อย',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถเพิ่มสมาชิกได้: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ฟังก์ชันดึงรายชื่อสมาชิกจาก SharedPreferences
  Future<void> fetchMembers() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> members = [];

    // ดึงข้อมูลผู้ใช้ที่ลงทะเบียนผ่าน RegisterPage
    String? registeredUsername = prefs.getString('username');
    String? registeredEmail = prefs.getString('email');
    String? registeredPassword = prefs.getString('password');
    if (registeredUsername != null && registeredEmail != null && registeredPassword != null) {
      // เพิ่มผู้ใช้ที่ลงทะเบียนผ่าน RegisterPage ลงในรายการสมาชิก
      members.add({
        'username': registeredUsername,
        'email': registeredEmail,
        'password': registeredPassword
      });
    }

    // ดึงข้อมูลสมาชิกที่ถูกเพิ่มผ่าน MemberListPage
    int memberCount = prefs.getInt('member_count') ?? 0;
    for (int i = 0; i < memberCount; i++) {
      String? username = prefs.getString('member_username_$i');
      String? email = prefs.getString('member_email_$i');
      String? password = prefs.getString('member_password_$i');
      if (username != null && email != null && password != null) {
        members.add({'username': username, 'email': email, 'password': password});
      }
    }

    membersList.value = members; // อัปเดต Observable List
  }

  // ฟังก์ชันลบสมาชิกจาก SharedPreferences
  Future<void> deleteMember(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int memberCount = prefs.getInt('member_count') ?? 0;

      // ลบข้อมูลสมาชิกที่ index ออก
      for (int i = index; i < memberCount - 1; i++) {
        String? nextUsername = prefs.getString('member_username_${i + 1}');
        String? nextEmail = prefs.getString('member_email_${i + 1}');
        String? nextPassword = prefs.getString('member_password_${i + 1}'); // ลบ password
        await prefs.setString('member_username_$i', nextUsername!);
        await prefs.setString('member_email_$i', nextEmail!);
        await prefs.setString('member_password_$i', nextPassword!); // เก็บ password ด้วย
      }

      // ลบข้อมูลสมาชิกสุดท้าย
      await prefs.remove('member_username_${memberCount - 1}');
      await prefs.remove('member_email_${memberCount - 1}');
      await prefs.remove('member_password_${memberCount - 1}'); // ลบ password
      await prefs.setInt('member_count', memberCount - 1);

      // อัปเดตรายการสมาชิกใหม่ใน Observable List
      membersList.removeAt(index);

      Get.snackbar(
        'สำเร็จ', 
        'สมาชิกถูกลบเรียบร้อย',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถลบสมาชิกได้: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ฟังก์ชันออกจากระบบ
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ล้างข้อมูลการล็อกอิน
    Get.offAll(() => const LoginPage()); // กลับไปที่หน้า Login
  }
}
