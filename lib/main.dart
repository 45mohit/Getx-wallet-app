import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_app/screens/home.dart';

void main() async {
  //Using GetX for StateManagement and Navigation, GetX Storage for Local storage
  await GetStorage.init();
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Colors.white,
      ),
      home: HomePage()));
}
