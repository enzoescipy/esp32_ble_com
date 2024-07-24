import 'package:flutter/material.dart';
import 'package:flutter_wifi_direct_test/module/BLEserial.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';

class HomeController extends GetxController {
  BLEserial bleSerial = BLEserial("4fafc201-1fb5-459e-8fcc-c5c9c331914b", "beb5483e-36e1-4688-b7f5-ea07361b26a8", 'ESP32',
      (bool b) {}, (bool b) {}, (bool b) {}, (List<dynamic> b) {});

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
