import 'package:flutter_wifi_direct_test/app/routes/route.dart';
import 'package:flutter_wifi_direct_test/app/screen/Root/controller/root_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootView extends GetView<RootController> {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        return Scaffold(
          body: GetRouterOutlet(initialRoute: Routes.HOME),
        );
      },
    );
  }
}
