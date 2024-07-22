import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Button Layout Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // İlk Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(), // Boşluk bırakmak için
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('İleri'),
                  ),
                  Expanded(
                    child: Container(), // Boşluk bırakmak için
                  ),
                ],
              ),
              // İki Row arasındaki boşluğu kısaltıyoruz
              SizedBox(height: 8.0), // İki Row arasındaki mesafe
              // İkinci Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Sola'),
                  ),
                  SizedBox(width: 8.0), // Butonlar arasındaki mesafe
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Sağa'),
                  ),
                ],
              ),
              // Üçüncü Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(), // Boşluk bırakmak için
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Geri'),
                  ),
                  Expanded(
                    child: Container(), // Boşluk bırakmak için
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
