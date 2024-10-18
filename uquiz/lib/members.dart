import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uquiz/controllers.dart'; // เรียกใช้ UQuizController

class MemberListPage extends StatelessWidget {
  const MemberListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UQuizController>(); // เรียกใช้ UQuizController

    return Scaffold(
      appBar: AppBar(
        title: const Text("Member Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Member',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Form สำหรับเพิ่มสมาชิกใหม่
            TextField(
              controller: ctrl.usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl.memberPasswordController, // สำหรับ password
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // ปิดการแสดง password
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ctrl.addMember(
                  ctrl.usernameController.text, // ส่งค่า username
                  ctrl.emailController.text,
                  ctrl.memberPasswordController.text, // ส่งค่า password
                );
              },
              child: const Text('Add Member'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Members List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // แสดงรายการสมาชิก
            Expanded(
              child: Obx(() {
                if (ctrl.membersList.isEmpty) {
                  return const Center(child: Text('No members found'));
                }

                return ListView.builder(
                  itemCount: ctrl.membersList.length,
                  itemBuilder: (context, index) {
                    final member = ctrl.membersList[index];
                    return ListTile(
                      title: Text(member['username']),
                      subtitle: Text('Email: ${member['email']} \nPassword: ${member['password']}'), // แสดง password
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ctrl.deleteMember(index); // ลบสมาชิกที่เลือก
                        },
                      ),
                    );
                  },
                );
              }),
            ),
            const Spacer(), // ดันให้ปุ่มไปอยู่ด้านล่าง
            ElevatedButton(
              onPressed: () {
                ctrl.logout(); // เรียกใช้ฟังก์ชันออกจากระบบ
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // เปลี่ยนสีปุ่มเป็นสีแดง
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
