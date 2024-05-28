import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:inventory_statocart/app.dart';
import 'package:inventory_statocart/models/product_model.dart';
import 'package:inventory_statocart/navigation_bar.dart';
import 'package:inventory_statocart/widgets/view_data.dart';

void main() {
  Get.put(SheetApi());
  Get.put(NavigationController());
  runApp( MyApp());
}



  // This widget is the root of your application.
