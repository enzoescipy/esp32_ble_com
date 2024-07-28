import 'package:flutter/material.dart';
import 'package:flutter_wifi_direct_test/module/BLEserial.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';

class HomeController extends GetxController {
  late BLEserial bleSerial;
  List<StreamSubscription<dynamic>> subscriptionList = [];
  TextEditingController comWindow = TextEditingController();

  void onDeviceFoundTap() {
    bleSerial.startScan();
  }

  void onJoinTap() {
    bleSerial.connectToDevice();
  }

  void onListenTap() {
    bleSerial.openReadStreamSample();
  }

  void onWriteTap() async {
    bleSerial.writePing((p0) => null);
  }

  void addComWindow(List<dynamic> s) {
    comWindow.text = comWindow.text + s.toString();
  }
}
