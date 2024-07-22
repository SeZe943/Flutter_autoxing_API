import 'package:flutter/material.dart';
import 'fonksiyonlar.dart'; // RemoteKontrol dosyasını import edin

class Pencere1 extends StatelessWidget {
  const Pencere1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Panel'),
      ),
      body: const Column(
        children: [
          // RemoteKontrol için Column
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: RemoteControlPage(), // RemoteKontrol widget'ı
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
