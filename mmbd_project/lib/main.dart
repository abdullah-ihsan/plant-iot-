import 'package:flutter/material.dart';
import 'package:mmbd_project/models/PlantList.dart';
import 'package:mmbd_project/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlantList(),
      builder: (context, child) => const MaterialApp(
        title: "Plant",
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
