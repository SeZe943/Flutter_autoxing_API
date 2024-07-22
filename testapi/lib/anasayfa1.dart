import 'package:flutter/material.dart';

class Anasayfa1 extends StatefulWidget {
  const Anasayfa1({super.key});

  @override
  _Anasayfa1State createState() => _Anasayfa1State();
}

class _Anasayfa1State extends State<Anasayfa1> {
  String _selectedRobot = 'Robot 1';
  String _imagePath = 'lib/assets/images/robot1.png'; // Varsayılan resim yolu

  void _onRobotSelected(String? selectedRobot) {
    if (selectedRobot != null) {
      setState(() {
        _selectedRobot = selectedRobot;
        // Resim yolunu seçilen robota göre ayarla
        if (selectedRobot == 'Robot 1') {
          _imagePath = 'lib/assets/images/robot1.png';
        } else if (selectedRobot == 'Robot 2') {
          _imagePath = 'lib/assets/images/robot2.png';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robot Seçimi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedRobot,
              onChanged: _onRobotSelected,
              items: <String>['Robot 1', 'Robot 2']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Seçilen Robot: $_selectedRobot',
              style: const TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20.0),
            Image.asset(_imagePath), // Seçilen robotun resmini gösterir
          ],
        ),
      ),
    );
  }
}
