import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/server_controller.dart';
import '../../widgets/button.dart';
import '../log_page/log_page.dart';

class InitServerPage extends StatefulWidget {
  const InitServerPage({super.key});

  @override
  State<InitServerPage> createState() => _InitServerPageState();
}

class _InitServerPageState extends State<InitServerPage> {
  final ServerController _serverController = Get.find();

  @override
  void initState() {
    super.initState();
    _initServer();
  }

  Future<void> _initServer() async {
    await _serverController.initServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Server Setup")),
      body: Center(
        child: GetBuilder<ServerController>(builder: (logic) {
          final wsUrl = logic.socketUrl;
          final serverInitialized = logic.serverInitialized;
          final errorMessage = logic.errorMessage;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    serverInitialized
                        ? Icons.check_circle_outline
                        : Icons.sync,
                    color: serverInitialized ? Colors.green : Colors.blue,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  SelectableText(
                    serverInitialized && wsUrl != null
                        ? '✅ Server is running!'
                        : '🚀 Starting server...',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.redAccent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SelectableText(
                              errorMessage,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (serverInitialized && wsUrl != null) ...[
                    SelectableText(
                      "WebSocket URL:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SelectableText(
                      wsUrl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Button(
                      text: 'Go to Log Screen',
                      onTap: (start, stop, state) {
                        Get.off(() => LogPage());
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  Button(
                    text: 'Close Server',
                    onTap: (start, stop, state) {
                      _serverController.closeServer();
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
