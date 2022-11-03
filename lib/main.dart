import 'package:adf_get_connect/pages/home/home_controller.dart';
import 'package:adf_get_connect/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
            name: '/',
            binding: BindingsBuilder(() {
              Get.lazyPut(() => UserRepository());
              Get.put(HomeController(repository: Get.find()));
            }),
            page: () => const HomePage()),
      ],
    );
  }
}
