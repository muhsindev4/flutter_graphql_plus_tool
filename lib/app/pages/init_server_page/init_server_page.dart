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
      appBar: AppBar(title: const Text("Initializing Server")),
      body: Center(
        child: GetBuilder<ServerController>(builder: (logic) {
          final wsUrl = _serverController.socketUrl;
          final serverInitialized = _serverController.serverInitialized;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!serverInitialized&&wsUrl==null)...[
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
              ],

              Text(
                (serverInitialized&&wsUrl!=null) ? '✅ Server started!' : '🚀 Starting server...',
              ),
              const SizedBox(height: 10),
              if (serverInitialized && wsUrl != null)...[
                Text("WebSocket URL:\n$wsUrl", textAlign: TextAlign.center),
                Button(text: 'Go to log screen',
                onTap: (start,stop,state){
                  Get.off(() =>  LogPage());
                },),
              ],

              Button(text: 'Close Server',
                onTap: (start,stop,state){
                  _serverController.closeServer();
                },),

            ],
          );
        }),
      ),
    );
  }
}
