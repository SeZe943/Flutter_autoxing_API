import 'package:flutter/material.dart';
import 'pencere1.dart'; // `Pencere1`in bulunduğu dosya
import 'pencere2.dart'; // `Pencere2`nin bulunduğu dosya
import 'pencere3.dart';
import 'fonksiyonlar.dart'; // `Anasayfa1`in bulunduğu dosya

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const Anasayfa1(), // `Anasayfa1` widget'ı burada ekleniyor
    const Pencere1(),
    const Pencere2(), // `Pencere2` widget'ı burada ekleniyor
    const Pencere3(),
    const Center(child: Text('Pencere 3', style: TextStyle(fontSize: 24))),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.control_camera),
            label: 'Pencere 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pencere 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Pencere 3',
          ),
        ],
        backgroundColor: Colors.black87, // Daha koyu renk
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: const Color.fromARGB(255, 101, 109, 140),
      ),
    );
  }
}
