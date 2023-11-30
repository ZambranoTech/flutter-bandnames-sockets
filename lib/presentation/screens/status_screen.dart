import 'package:band_names/presentation/providers/socket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = context.watch<SocketProvider>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Estado: ${socketService.serverStatus}')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.emit('emitir-mensaje', { 
            'nombre': 'Flutter',
            'mensaje': 'Hola desde Flutter',
          });
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
