
import 'package:flutter/material.dart';
import 'Fonksiyonlar.dart';
//import 'remote_control.dart'; // RemoteControlPage import edin
//import 'jack_control.dart'; // JackControlPage import edin

class Pencere3 extends StatelessWidget {
  const Pencere3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Panel'),
      ),
      body: const Column(
        children: [
          // RemoteControlPage için Column
          // JackControlPage için Column
          Expanded(
            child: Padding(
              padding:  EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: JackControlPage(title: 'Jack Control'), // JackControlPage widget'ı
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
