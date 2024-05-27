
import 'package:flutter/material.dart';
import 'package:inventory_statocart/navigation_bar.dart';
import 'package:inventory_statocart/widgets/view_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sheets API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
       home: const NavigationMenu(),
    );

  }
}