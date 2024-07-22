// import 'package:flutter/material.dart';
// import 'pencere1.dart'; // `Pencere1`'in bulunduğu dosya
// import 'pencere2.dart'; // `Pencere2`'nin bulunduğu dosya
// import 'pencere3.dart';

// class Anasayfa extends StatefulWidget {
//   const Anasayfa({super.key});

//   @override
//   _AnasayfaState createState() => _AnasayfaState();
// }

// class _AnasayfaState extends State<Anasayfa> {
//   int _currentIndex = 0;
//   String? _selectedRobot;

//   final List<Widget> _children = [
//     const Center(child: Text('Anasayfa', style: TextStyle(fontSize: 24))),
//     const Pencere1(),
//     const Pencere2(), // `Pencere2` widget'ı burada ekleniyor
//     const Pencere3(),
//   ];

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   void _onRobotSelected(String? value) {
//     setState(() {
//       _selectedRobot = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Anasayfa'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButton<String>(
//               value: _selectedRobot,
//               hint: const Text('Bir robot seçin'),
//               items: [
//                 DropdownMenuItem(
//                   value: 'robot1',
//                   child: Text('Robot 1'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'robot2',
//                   child: Text('Robot 2'),
//                 ),
//               ],
//               onChanged: _onRobotSelected,
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: _selectedRobot == null
//                   ? const Text('Lütfen bir robot seçin')
//                   : _selectedRobot == 'robot1'
//                       ? Image.asset('lib/assets/images/robot1.png')
//                       : Image.asset('lib/assets/images/robot2.png'),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: onTabTapped,
//         currentIndex: _currentIndex,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Anasayfa',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.control_camera),
//             label: 'Pencere 1',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Pencere 2',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.info),
//             label: 'Pencere 3',
//           ),
//         ],
//         backgroundColor: Colors.black87, // Daha koyu renk
//         selectedItemColor: Colors.deepPurple,
//         unselectedItemColor: Color.fromARGB(255, 101, 109, 140),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'pencere1.dart'; // `Pencere1`'in bulunduğu dosya
import 'pencere2.dart'; // `Pencere2`'nin bulunduğu dosya
import 'pencere3.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const Center(child: Text('Anasayfa', style: TextStyle(fontSize: 24))),
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
        unselectedItemColor: Color.fromARGB(255, 101, 109, 140),
      ),
    );
  }
}
