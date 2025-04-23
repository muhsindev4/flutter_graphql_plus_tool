import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/log_controller.dart';

class LogPage extends StatelessWidget {
  final LogController _logController = Get.find();

  LogPage({super.key});

  String formatJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        _logController.clearAll();
      },
        child: Icon(Icons.clear),
      ),
      appBar: AppBar(title: const Text('GraphQL Request Logs')),
      body: GetBuilder<LogController>(
        builder: (logic) {
          return ListView.builder(
            itemCount: _logController.logs.length,
            itemBuilder: (context, index) {
              final log = _logController.logs[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    '${log.operationType.name.toUpperCase()} • ${log.operationName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${log.durationMs} ms • ${log.timestamp}'),
                  trailing: log.errorMessage != null
                      ? const Icon(Icons.error_outline, color: Colors.red)
                      : const Icon(Icons.check_circle_outline, color: Colors.green),
                  children: [
                    _buildSection('Query', log.query),
                    if (log.variables != null)
                      _buildSection('Variables', formatJson(log.variables!)),
                    if (log.responseData != null)
                      _buildSection('Response', formatJson(log.responseData as Map<String, dynamic>)),
                    if (log.errorMessage != null)
                      _buildSection('Error', log.errorMessage!, isError: true),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isError ? Colors.red : Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isError ? Colors.red.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                content,
                style: const TextStyle(fontSize: 13, fontFamily: 'Courier',color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
