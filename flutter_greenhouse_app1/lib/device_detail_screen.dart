import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'services/api_service.dart';
import 'models/telemetry.dart';
import 'auth_service.dart';
import 'device_alerts_screen.dart';
import 'widgets/telemetry_chart.dart';

class DeviceDetailScreen extends StatefulWidget {
  final int deviceId;
  final String deviceName;

  const DeviceDetailScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final ApiService api = ApiService();

  final List<Telemetry> _telemetryList = [];
  WebSocketChannel? _channel;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistoryAndConnect();
  }

  Future<void> _loadHistoryAndConnect() async {
    try {
      // 1) Historique HTTP
      final history = await api.getDeviceTelemetry(widget.deviceId);

      setState(() {
        _telemetryList.addAll(history.reversed);
        _loading = false;
      });

      // 2) WebSocket avec token
      final token = AuthService.token;

      _channel = WebSocketChannel.connect(
        Uri.parse(
          'ws://127.0.0.1:8000/ws/telemetry/${widget.deviceId}/?token=$token',
        ),
      );

      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data is Map<String, dynamic>) {
            final t = Telemetry.fromJson(data);
            setState(() {
              _telemetryList.insert(0, t);
            });
          } else {
            debugPrint('Unexpected WS message: $data');
          }
        },
        onError: (e) {
          setState(() {
            _error = "WebSocket error: $e";
          });
        },
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deviceName),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeviceAlertsScreen(
                    deviceId: widget.deviceId,
                    deviceName: widget.deviceName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text("Error: $_error"))
            : _telemetryList.isEmpty
            ? const Center(child: Text("No telemetry for this device"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Telemetry chart",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: TelemetryChart(telemetry: _telemetryList),
                  ),
                  const SizedBox(height: 16),
                  // Si tu veux garder juste une info texte
                  Text(
                    "Latest value: ${_telemetryList.first.value} at ${_telemetryList.first.timestamp.toLocal()}",
                  ),
                  // Si tu préfères, tu peux remettre ta ListView ici
                  // dans un Expanded pour garder la liste + le chart
                ],
              ),
      ),
    );
  }
}
