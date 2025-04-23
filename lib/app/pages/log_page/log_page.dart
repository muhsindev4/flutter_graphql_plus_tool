import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/log_controller.dart';

class LogPage extends StatelessWidget{

  final LogController _logController=Get.find();

  LogPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GraphQL Request Logs')),
      body: GetBuilder<LogController>(
          builder: (logic) {
            return ListView.builder(
              itemCount: _logController.logs.length,
              itemBuilder: (context, index) {
                final log = _logController.logs[index];
                return ExpansionTile(
                  title: Text('${log.operationType.name} • ${log.operationName}'),
                  subtitle: Text('${log.durationMs} ms • ${log.timestamp}'),
                  trailing: log.errorMessage != null
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check_circle, color: Colors.green),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Query: ${log.query}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          if (log.variables != null) Text('Variables: ${jsonEncode(log.variables)}'),
                          const SizedBox(height: 4),
                          if (log.responseData != null) Text('Response: ${jsonEncode(log.responseData)}'),
                          if (log.errorMessage != null)
                            Text('Error: ${log.errorMessage}', style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          }
      ),
    );
  }
}