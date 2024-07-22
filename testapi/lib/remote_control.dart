import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Control App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RemoteControlPage(),
    );
  }
}

class RemoteControlPage extends StatefulWidget {
  const RemoteControlPage({super.key});

  @override
  _RemoteControlPageState createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  late WebSocketChannel channel;
  String _responseMessage = "";

  @override
  void initState() {
    super.initState();
    setControlMode();
    channel = IOWebSocketChannel.connect('ws://10.3.0.78:8090/ws/v2/topics');
  }

  Future<void> setControlMode() async {
    const url = "http://10.3.0.78:8090/services/wheel_control/set_control_mode";
    final headers = {'Content-Type': 'application/json'};
    final data = jsonEncode({"control_mode": "remote"});

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: data);
      if (response.statusCode < 202) {
        setState(() {
          _responseMessage = "Kontrol modu 'remote' olarak ayarlandı.";
        });
      } else {
        setState(() {
          _responseMessage = "Kontrol modu ayarlanamadı. Durum kodu: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = "Kontrol modu ayarlanamadı. Hata: $e";
      });
    }
  }

  void sendTwistCommand(double linearVelocity, double angularVelocity) {
    channel.sink.add(jsonEncode({
      "topic": "/twist",
      "linear_velocity": linearVelocity,
      "angular_velocity": angularVelocity,
    }));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Widget buildControlButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: 100,  // Buton genişliği
      height: 100, // Buton yüksekliği
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Buton arka plan rengi
          foregroundColor: Colors.white, // Buton üzerindeki yazının rengi
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robot Control'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // İlk Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildControlButton('İleri', () => sendTwistCommand(0.5, 0)),
                  ],
                ),
                SizedBox(height: 16.0), // İki Row arasındaki boşluk
                // İkinci Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildControlButton('Sola', () => sendTwistCommand(0, 0.5)),
                    SizedBox(width: 16.0), // Butonlar arasındaki mesafe
                    buildControlButton('Sağa', () => sendTwistCommand(0, -0.5)),
                  ],
                ),
                SizedBox(height: 16.0), // İki Row arasındaki boşluk
                // Üçüncü Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildControlButton('Geri', () => sendTwistCommand(-0.5, 0)),
                  ],
                ),
                SizedBox(height: 32.0), // Sonundaki boşluk
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      _responseMessage,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
