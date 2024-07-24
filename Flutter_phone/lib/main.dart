import 'package:flutter/material.dart';
import 'package:flutter_wifi_direct_test/module/BLEserial.dart';
import 'package:get/get.dart';

import 'package:flutter_wifi_direct_test/app/routes/route.dart';

Future<void> main() async {
  ///파이어베이스 연동
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp.router(
      initialBinding: BindingsBuilder(
        () async {
          // 초기화 하면서 서비스를 가져온다.
          // Get.put(BLEserialService());
        },
      ),
      // builder: EasyLoading.init(),
      getPages: AppPages.routes,
    ),
  );
}
