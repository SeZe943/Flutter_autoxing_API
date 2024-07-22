import 'package:flutter/material.dart';
import 'Fonksiyonlar.dart';
//import 'Anlik_veri.dart';
//import 'Konum_degistirme.dart';

class Pencere2 extends StatelessWidget {
  const Pencere2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anlık Veri ve Konum Değiştirme'),
      ),
      body: const Column(
        children: [
          Expanded(
            child: AnlikVeri(), // Anlık veri widget'ı
          ),
          Expanded(
            child: KonumDegistirme(), // Konum değiştirme widget'ı
          ),
        ],
      ),
    );
  }
}
