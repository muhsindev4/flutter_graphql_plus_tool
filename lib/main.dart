import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_graphql_plus_tool/app/controllers/log_controller.dart';
import 'package:flutter_graphql_plus_tool/app/pages/init_server_page/init_server_page.dart';
import 'package:get/get.dart';

import 'app/controllers/server_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LogController());
  Get.put(ServerController()).initServer();

  runApp(const RequestLoggerApp());
}

class RequestLoggerApp extends StatelessWidget {
  const RequestLoggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GraphQL Request Logger',
      theme: ThemeData.dark(),
      home:  InitServerPage(),
    );
  }
}


