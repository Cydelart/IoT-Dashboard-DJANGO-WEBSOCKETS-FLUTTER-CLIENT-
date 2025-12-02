<<<<<<< HEAD
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'services/api_service.dart';
import 'models/telemetry.dart';
import 'auth_service.dart';
=======
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'services/api_service.dart';
import 'models/telemetry.dart';
import 'services/auth_service.dart';
>>>>>>> b8df76b (final version)
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
<<<<<<< HEAD

=======
>>>>>>> b8df76b (final version)
  final List<Telemetry> _telemetryList = [];
  WebSocketChannel? _channel;
  bool _loading = true;
  String? _error;
<<<<<<< HEAD
=======
  Timer? _timer;
>>>>>>> b8df76b (final version)

  @override
  void initState() {
    super.initState();
    _loadHistoryAndConnect();
<<<<<<< HEAD
=======

    // Timer pour mettre à jour l'affichage toutes les secondes
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  // Fenêtre des 2 dernières minutes
  List<Telemetry> _last2Minutes(List<Telemetry> list) {
    final cutoff = DateTime.now().subtract(const Duration(minutes: 2));
    return list.where((t) => t.timestamp.isAfter(cutoff)).toList();
>>>>>>> b8df76b (final version)
  }

  Future<void> _loadHistoryAndConnect() async {
    try {
      // 1) Historique HTTP
      final history = await api.getDeviceTelemetry(widget.deviceId);
<<<<<<< HEAD

      setState(() {
        _telemetryList.addAll(history.reversed);
        _loading = false;
      });

      // 2) WebSocket avec token
      final token = AuthService.token;

=======
      setState(() {
        _telemetryList.addAll(_last2Minutes(history.reversed.toList()));
        _loading = false;
      });

      // 2) WebSocket
      final token = AuthService.token;
>>>>>>> b8df76b (final version)
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
<<<<<<< HEAD
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
=======

            setState(() {
              _telemetryList.insert(0, t); // newest first

              // remove values older than 2 minutes
              _telemetryList.removeWhere(
                (x) => x.timestamp.isBefore(
                  DateTime.now().subtract(const Duration(minutes: 2)),
                ),
              );
            });
          }
        },
        onError: (e) {
          setState(() => _error = "WebSocket error: $e");
>>>>>>> b8df76b (final version)
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
<<<<<<< HEAD
=======
    _timer?.cancel();
>>>>>>> b8df76b (final version)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
    final displayedTelemetry = _last2Minutes(_telemetryList);

>>>>>>> b8df76b (final version)
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
<<<<<<< HEAD
        padding: const EdgeInsets.all(16.0),
=======
        padding: const EdgeInsets.all(16),
>>>>>>> b8df76b (final version)
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text("Error: $_error"))
<<<<<<< HEAD
            : _telemetryList.isEmpty
=======
            : displayedTelemetry.isEmpty
>>>>>>> b8df76b (final version)
            ? const Center(child: Text("No telemetry for this device"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
<<<<<<< HEAD
                    "Telemetry chart",
=======
                    "Telemetry chart (last 2 minutes)",
>>>>>>> b8df76b (final version)
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
<<<<<<< HEAD
                    child: TelemetryChart(telemetry: _telemetryList),
                  ),
                  const SizedBox(height: 16),
                  // Si tu veux garder juste une info texte
                  Text(
                    "Latest value: ${_telemetryList.first.value} at ${_telemetryList.first.timestamp.toLocal()}",
                  ),
                  // Si tu préfères, tu peux remettre ta ListView ici
                  // dans un Expanded pour garder la liste + le chart
=======
                    child: TelemetryChart(telemetry: displayedTelemetry),
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (_) {
                      final latest = displayedTelemetry.first;
                      return Text(
                        "Latest value: ${latest.value} "
                        "at ${latest.timestamp.toLocal()}",
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
>>>>>>> b8df76b (final version)
                ],
              ),
      ),
    );
  }
}
