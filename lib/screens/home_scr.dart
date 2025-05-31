//prvi ekran, na njemu imam drawer sa strane i ubaciću ono za redare prećenje smene itd

import 'package:flutter/material.dart';
import 'package:redarko/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      drawer: const AppDrawer(),
      body: const Center(child: Text("Home sadržaj")),
    );
  }
}
