import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:developer';
import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_wifi_direct_test/module/list.dart';

class BLEserial {
  // serialized data queues for reading and writing
  List<int> serialBufferQueue = [];
  List<int> encodedBufferQueue = [];
  List<int> replyNotify = [];
  int encodedBuffer_endsignPos = 0;
  late Function(List<dynamic>) replyNotify_callback; // sign will be given by List<int>. can be null like []

  // ble state management booleans
  bool _scanStarted = false;
  late Function(bool) scanStarted_callback; // state will be given by bool
  bool _deviceFounded = false;
  late Function(bool) deviceFounded_callback; // state will be given by bool
  bool _connected = false;
  late Function(bool) connected_callback; // state will be given by bool

  // BLE original objects
  BluetoothDevice? _uniqueDevice; // device information object

  // UUIDs and informations of your targeted device
  late Guid serviceUuid;
  late Guid characteristicNotifyUuid;
  late Guid characteristicWriteUuid;
  late String targetedDeviceName;

  BLEserial(String serviceUuidString, String characteristicNotifyUuidString, String characteristicWriteUuidString, this.targetedDeviceName, this.deviceFounded_callback,
      this.scanStarted_callback, this.connected_callback, this.replyNotify_callback) {
    serviceUuid = Guid.fromString(serviceUuidString);
    characteristicNotifyUuid = Guid.fromString(characteristicNotifyUuidString);
    characteristicWriteUuid = Guid.fromString(characteristicWriteUuidString);
  }

  Future<void> startScan() async {
    // bool permGranted = false;
    _scanStarted = true;
    scanStarted_callback(_scanStarted);

    await FlutterBluePlus.startScan(
      withNames: [targetedDeviceName],
    );

    FlutterBluePlus.scanResults.listen((event) {
      for (ScanResult result in event) {
        _uniqueDevice = result.device;
      }
    });

    if (_uniqueDevice != null) {
      _deviceFounded = true;
    }
  }

  Future<void> connectToDevice() async {
    await _uniqueDevice?.connect();
    _connected = true;
  }

  Future<void> openReadStreamSample() async {
    if (_connected == false || _uniqueDevice == null) {
      throw Exception(
          ["stringFormat.connectToDevice() : _connected is not true. please validate the param before call this function."]);
    }
    final serviceList = await _uniqueDevice?.discoverServices();
    for (BluetoothService service in serviceList!) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicNotifyUuid) {
          await characteristic.setNotifyValue(true);
          characteristic.lastValueStream.listen((event) {
            print(event.toString());
          });
        }
      }
    }
  }

  Future<void> writePing(Function(void) call) async {
    if (_connected == false) {
      throw Exception(
          ["stringFormat.connectToDevice() : _connected is not true. please validate the param before call this function."]);
    }
    String foo = 'I_am_flutter';
    List<int> bytes = ascii.encode(foo);

    final serviceList = await _uniqueDevice?.discoverServices();
    for (BluetoothService service in serviceList!) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicWriteUuid) {
          await characteristic.write(bytes).then((value) => call);
        }
      }
    }
  }
}
