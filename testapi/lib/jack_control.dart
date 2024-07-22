import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String BASE_URL = "http://10.3.0.78:8090"; // BASE_URL'i kendi URL'nizle değiştirin

void main() {
  runApp(JackControlApp());
}

class JackControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lift Kontrol APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JackControlPage(title: 'Lift Sistemi Kontrol Uygulaması'),
    );
  }
}

class JackControlPage extends StatefulWidget {
  final String title;

  const JackControlPage({required this.title, Key? key}) : super(key: key);

  @override
  _JackControlPageState createState() => _JackControlPageState();
}

class _JackControlPageState extends State<JackControlPage> {
  Future<void> jackUp() async {
    try {
      var url = Uri.parse('$BASE_URL/services/jack_up');
      var response = await http.post(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        if (mounted) {
          _showSnackbar('Lift kaldırma başarılı');
          await Future.delayed(Duration(seconds: 2));
          if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        }
      } else {
        if (mounted) {
          _showSnackbar('Lift kaldırma başarısız. Hata kodu: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar('Lift kaldırma sırasında hata oluştu: $e');
      }
    }
  }

  Future<void> jackDown() async {
    try {
      var url = Uri.parse('$BASE_URL/services/jack_down');
      var response = await http.post(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        if (mounted) {
          _showSnackbar('Lift indirme başarılı');
          await Future.delayed(Duration(seconds: 2));
          if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        }
      } else {
        if (mounted) {
          _showSnackbar('Lift indirme başarısız. Hata kodu: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar('Lift indirme sırasında hata oluştu: $e');
      }
    }
  }

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Buton arka plan rengi
                foregroundColor: Colors.white, // Buton üzerindeki yazının rengi
              ),
              onPressed: jackUp,
              child: const Text('Lift Kaldır'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Buton arka plan rengi
                foregroundColor: Colors.white, // Buton üzerindeki yazının rengi
              ),
              onPressed: jackDown,
              child: const Text('Lift İndir'),
            ),
          ],
        ),
      ),
    );
  }
}
