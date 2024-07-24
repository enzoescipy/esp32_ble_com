import 'package:flutter_wifi_direct_test/app/screen/ROOT/controller/ROOT_controller.dart';
import 'package:get/get.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RootController>(RootController());
  }
}
