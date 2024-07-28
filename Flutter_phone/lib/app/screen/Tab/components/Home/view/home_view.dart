import "package:flutter_wifi_direct_test/module/BLEserial.dart";
import "package:get/get.dart";
import 'package:flutter/material.dart';

import "package:flutter_wifi_direct_test/app/screen/Tab/components/Home/controller/home_controller.dart";

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: MaterialButton(
                  child: const Icon(Icons.looks_one_rounded),
                  onPressed: () {
                    controller.bleSerial = BLEserial(
                        "4fafc201-1fb5-459e-8fcc-c5c9c331914b",
                        "beb5483e-36e1-4688-b7f5-ea07361b26a8",
                        "118c877b-59b9-4610-827c-d5173aed4c27",
                        'ESP32',
                        (bool b) {},
                        (bool b) {},
                        (bool b) {}, (List<dynamic> b) {
                      controller.addComWindow(b);
                    });
                    controller.onDeviceFoundTap();
                  }),
            ),
            Expanded(
              child: MaterialButton(
                  child: const Icon(Icons.looks_two_rounded),
                  onPressed: () {
                    controller.onJoinTap();
                  }),
            ),
            Expanded(
              child: MaterialButton(
                  child: const Icon(Icons.looks_3_rounded),
                  onPressed: () {
                    controller.onListenTap();
                  }),
            ),
            Expanded(
              child: MaterialButton(
                  child: const Icon(Icons.people),
                  onPressed: () {
                    controller.onWriteTap();
                  }),
            )
          ]),
        ),
        TextField(
          readOnly: true,
          controller: controller.comWindow,
        )
      ],
    );
  }
}
