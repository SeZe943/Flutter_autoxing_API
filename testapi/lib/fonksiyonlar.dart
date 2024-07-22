import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

const String baseURL = "10.3.0.78:8090"; // baseURL'i kendi URL'nizle değiştirin
//----------------------------------------------------------------------------------------------------
//-------  KONUM DEĞİŞTİRME  -------------------------------------------------------------------------------import 'package:flutter/material.dart';

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


//-------  ANLIK VERİ -------------------------------------------------------------------------------
class AnlikVeri extends StatelessWidget {
  const AnlikVeri({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AnlikVeriWidget();
  }
}

class _AnlikVeriWidget extends StatefulWidget {
  const _AnlikVeriWidget();

  @override
  State<_AnlikVeriWidget> createState() => _AnlikVeriWidgetState();
}

class _AnlikVeriWidgetState extends State<_AnlikVeriWidget> {
  late WebSocketChannel channel;
  String _responseMessage = "";
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    // WebSocket connection setup
    channel = IOWebSocketChannel.connect('ws://$baseURL/ws/v2/topics');
    // Subscribe to the tracked_pose topic
    subscribeToTrackedPose();
  }

  void subscribeToTrackedPose() async {
    if (!_isSubscribed) {
      final subscribeMessage = jsonEncode({"enable_topic": "/tracked_pose"});
      channel.sink.add(subscribeMessage);
      // Listen to messages from WebSocket server
      channel.stream.listen((message) {
        final data = jsonDecode(message);
        if (data['topic'] == '/tracked_pose') {
          final pos = data['pos'] ?? [];
          final ori = data['ori'];
          setState(() {
            _responseMessage = "Position: X=${pos.length > 0 ? pos[0] : '-'}, Y=${pos.length > 1 ? pos[1] : '-'}, Orientation=$ori";
          });
          _isSubscribed = true; // Mark as subscribed after receiving first data
        }
      });
    }
  }

  void fetchRobotPosition() async {
    final fetchMessage = jsonEncode({"request_type": "fetch_pose"});
    channel.sink.add(fetchMessage);
  }

  @override
  void dispose() {
    channel.sink.close(); // Close WebSocket connection when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anlik Veri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                fetchRobotPosition(); // Fetch new position data
                _isSubscribed = false;
              },
              child: const Text('Konum Verisi Al'),
            ),
            const SizedBox(height: 16),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------------------------------
//-------  KONUM DEĞİŞTİRME  -------------------------------------------------------------------------------
class KonumDegistirme extends StatefulWidget {
  const KonumDegistirme({super.key});

  @override
  _KonumDegistirmeState createState() => _KonumDegistirmeState();
}

class _KonumDegistirmeState extends State<KonumDegistirme> {
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  String _responseMessage = "";
  String _selectedOrientation = "ileri";

  Future<void> moveToTarget(String x, String y, String ori) async {
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
      Uri.parse('http://$baseURL/chassis/moves'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      var moveId = responseData["id"].toString(); // moveId'yi String'e dönüştürüyoruz
      monitorMoveStatus(moveId, baseURL);
    } else {
      setState(() {
        _responseMessage = "Hareket oluşturulamadi. Durum kodu: ${response.statusCode}";
      });
    }
  }

  Future<void> monitorMoveStatus(String moveId, String baseUrl) async {
    String url = "http://$baseURL/chassis/moves/$moveId";
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _xController,
            decoration: const InputDecoration(labelText: 'X Koordinati'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _yController,
            decoration: const InputDecoration(labelText: 'Y Koordinati'),
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
          ElevatedButton(
            onPressed: () async {
              await moveToTarget(_xController.text, _yController.text, _selectedOrientation);
            },
            child: const Text('Hareket Ettir'),
          ),
          Text(_responseMessage),
        ],
      ),
    );
  }
}

//----------------------------------------------------------------------------------------------------
//-------  JACK CONTROL  -------------------------------------------------------------------------------

class JackControlPage extends StatefulWidget {
  final String title;

  const JackControlPage({required this.title, super.key});

  @override
  _JackControlPageState createState() => _JackControlPageState();
}

class _JackControlPageState extends State<JackControlPage> {
  Future<void> jackUp() async {
    try {
      var url = Uri.parse('$baseURL/services/jack_up');
      var response = await http.post(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        if (mounted) {
          _showSnackbar('Lift kaldirma başarili');
          await Future.delayed(Duration(seconds: 2));
          if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        }
      } else {
        if (mounted) {
          _showSnackbar('Lift kaldirma başarisiz. Hata kodu: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar('Lift kaldirma sirasinda hata oluştu: $e');
      }
    }
  }

  Future<void> jackDown() async {
    try {
      var url = Uri.parse('$baseURL/services/jack_down');
      var response = await http.post(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        if (mounted) {
          _showSnackbar('Lift indirme başarili');
          await Future.delayed(Duration(seconds: 2));
          if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        }
      } else {
        if (mounted) {
          _showSnackbar('Lift indirme başarisiz. Hata kodu: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar('Lift indirme sirasinda hata oluştu: $e');
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
              onPressed: jackUp,
              child: const Text('Lift Kaldir'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: jackDown,
              child: const Text('Lift İndir'),
            ),
          ],
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------------------------------
//-------  REMOTE CONTROL  -------------------------------------------------------------------------------

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
      width: 60,  // Buton genişliği
      height: 60, // Buton yüksekliği
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.zero,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // İlk Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()), // Sol boşluk
                buildControlButton('İleri', () => sendTwistCommand(0.5, 0)),
                Expanded(child: Container()), // Sağ boşluk
              ],
            ),
            SizedBox(height: 8.0), // İki Row arasındaki boşluk
            // İkinci Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildControlButton('Sola', () => sendTwistCommand(0, 0.5)),
                SizedBox(width: 8.0), // Butonlar arasındaki mesafe
                buildControlButton('Sağa', () => sendTwistCommand(0, -0.5)),
              ],
            ),
            SizedBox(height: 8.0), // İki Row arasındaki boşluk
            // Üçüncü Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()), // Sol boşluk
                buildControlButton('Geri', () => sendTwistCommand(-0.5, 0)),
                Expanded(child: Container()), // Sağ boşluk
              ],
            ),
            SizedBox(height: 16.0), // Sonundaki boşluk
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  _responseMessage,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
