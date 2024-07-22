import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konum Değiştirme Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MoveScreen(),
    );
  }
}

class MoveScreen extends StatefulWidget {
  @override
  _MoveScreenState createState() => _MoveScreenState();
}

class _MoveScreenState extends State<MoveScreen> {
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  String _responseMessage = "";
  String _selectedOrientation = "ileri";

  Future<void> moveToTarget(String x, String y, String ori) async {
    String baseUrl = "http://10.3.0.78:8090";
    double orientation;

    if (ori == "ileri") {
      orientation = 1.5078;
    } else if (ori == "geri") {
      orientation = -1.5078;
    } else if (ori == "sag") {
      orientation = 0.0;
    } else if (ori == "sol") {
      orientation = 3.14;
    } else {
      setState(() {
        _responseMessage = "Geçersiz yön! Lütfen 'ileri', 'geri', 'sag', veya 'sol' kullanin.";
      });
      return;
    }

    var data = {
      "type": "standard",
      "target_x": double.tryParse(x) ?? 0.0,
      "target_y": double.tryParse(y) ?? 0.0,
      "target_z": 0.0,
      "target_ori": orientation,
    };

    var response = await http.post(
      Uri.parse('$baseUrl/chassis/moves'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      var moveId = responseData["id"].toString(); // moveId'yi String'e dönüştürüyoruz
      monitorMoveStatus(moveId, baseUrl);
    } else {
      setState(() {
        _responseMessage = "Hareket oluşturulamadi. Durum kodu: ${response.statusCode}";
      });
    }
  }

  Future<void> monitorMoveStatus(String moveId, String baseUrl) async {
    String url = "$baseUrl/chassis/moves/$moveId";
    String oldState = "";

    while (true) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String state = data["state"];
        if (state != oldState) {
          setState(() {
            _responseMessage = "Durum: $state";
          });
          oldState = state;
        }
        if (state == "succeeded" || state == "failed") {
          break;
        }
      } else {
        setState(() {
          _responseMessage = "Hata oluştu. Durum kodu: ${response.statusCode}";
        });
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konum Değiştirme Uygulaması'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _xController,
              decoration: const InputDecoration(labelText: 'X Koordinatı'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _yController,
              decoration: const InputDecoration(labelText: 'Y Koordinatı'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              items: const [
                DropdownMenuItem(value: "ileri", child: Text("İleri")),
                DropdownMenuItem(value: "geri", child: Text("Geri")),
                DropdownMenuItem(value: "sag", child: Text("Sağ")),
                DropdownMenuItem(value: "sol", child: Text("Sol")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedOrientation = value ?? "ileri";
                });
              },
              value: _selectedOrientation,
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  moveToTarget(_xController.text, _yController.text, _selectedOrientation);
                },
                child: const Text('Hareket Ettir'),
              ),
            ),
            SizedBox(height: 20),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}
