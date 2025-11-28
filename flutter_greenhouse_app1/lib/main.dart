import 'dart:convert'; // for jsonDecode
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart'; // for WebSocketChannel

import 'services/api_service.dart';
import 'models/telemetry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Agriculture',
      home: const DeviceListScreen(),
    );
  }
}

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final ApiService api = ApiService();
  late Future<List<dynamic>> futureDevices;

  @override
  void initState() {
    super.initState();
    futureDevices = api.getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Devices")),
      body: FutureBuilder<List<dynamic>>(
        future: futureDevices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final devices = snapshot.data ?? [];

          if (devices.isEmpty) {
            return const Center(child: Text("No devices found"));
          }

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final d = devices[index];
              final int deviceId = d["id"];

              return ListTile(
                title: Text(d["name"] ?? "Unnamed device"),
                subtitle: Text(
                  "${d["sensor_type"] ?? "Unknown"} — ${d["status"] ?? ""}",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceDetailScreen(
                        deviceId: deviceId,
                        deviceName: d["name"] ?? "Device",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

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

  // real-time state
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
      // 1) load history via HTTP
      final history = await api.getDeviceTelemetry(widget.deviceId);

      setState(() {
        _telemetryList.addAll(history.reversed); // newest first
        _loading = false;
      });

      // 2) open WebSocket for real-time updates
      _channel = WebSocketChannel.connect(
        // if you test on Android emulator, use 10.0.2.2 instead of 127.0.0.1
        Uri.parse('ws://127.0.0.1:8000/ws/telemetry/${widget.deviceId}/'),
      );

      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          final t = Telemetry.fromJson(data);

          setState(() {
            _telemetryList.insert(0, t); // insert new value at top
          });
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
    _channel?.sink.close(); // close WebSocket properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.deviceName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text("Error: $_error"))
            : _telemetryList.isEmpty
            ? const Center(child: Text("No telemetry for this device"))
            : ListView.builder(
                itemCount: _telemetryList.length,
                itemBuilder: (context, index) {
                  final t = _telemetryList[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.show_chart),
                      title: Text("Value: ${t.value}"),
                      subtitle: Text("At: ${t.timestamp.toLocal()}"),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
