import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uquiz/controllers.dart'; // เพื่อเรียกใช้ UQuizController
import 'home.dart';

class Shopping extends StatefulWidget {
  const Shopping({super.key});

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UQuizController>(); // หา UQuizController เพื่อเรียกใช้ logout()

    // url = 'https://fakestoreapi.com/products?limit=5'
    const images = [
      "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
      "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
      "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
      "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg",
      "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("UQuiz Shopping"),
      ),
      body: ListView.separated(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Center(child: Image.network(images[index]));
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(padding: EdgeInsets.all(8), child: Text(''));
        },
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          print('select page: $index');
          if (index == 0) {
            // ไปหน้า Home
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()));
          } else if (index == 2) {
            // ออกจากระบบ
            ctrl.logout(); // เรียกใช้ฟังก์ชัน logout จาก UQuizController
          }
        },
        selectedIndex: 1, // ตั้งให้เลือกหน้าร้านค้า
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.shop), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.logout), label: 'Logout'), // เปลี่ยนเป็นปุ่ม Logout
        ],
      ),
    );
  }
}
