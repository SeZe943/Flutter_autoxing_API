import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AnlikVeri extends StatelessWidget {
  const AnlikVeri({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AnlikVeriWidget();
  }
}

class _AnlikVeriWidget extends StatefulWidget {
  const _AnlikVeriWidget({super.key});

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
    channel = IOWebSocketChannel.connect('ws://10.3.0.78:8090/ws/v2/topics');
    // Subscribe to the tracked_pose topic
    subscribeToTrackedPose();
  }

  void subscribeToTrackedPose() {
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

  void fetchRobotPosition() {
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
        title: const Text('Anlık Veri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
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
