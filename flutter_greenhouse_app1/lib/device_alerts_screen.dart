import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'services/api_service.dart';
import 'models/alert.dart';
import 'auth_service.dart';
=======
import 'services/api_service.dart';
import 'models/alert.dart';
import 'services/auth_service.dart';
>>>>>>> b8df76b (final version)

class DeviceAlertsScreen extends StatefulWidget {
  final int deviceId;
  final String deviceName;

  const DeviceAlertsScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  State<DeviceAlertsScreen> createState() => _DeviceAlertsScreenState();
}

class _DeviceAlertsScreenState extends State<DeviceAlertsScreen> {
  final ApiService api = ApiService();
  late Future<List<AlertModel>> futureAlerts;

  @override
  void initState() {
    super.initState();
    futureAlerts = api.getDeviceAlerts(widget.deviceId);
  }

  void _reload() {
    setState(() {
      futureAlerts = api.getDeviceAlerts(widget.deviceId);
    });
  }

  Future<void> _resolveAlert(AlertModel alert) async {
    try {
      await api.resolveAlert(alert.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Alert resolved")));
      _reload();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error resolving alert: $e")));
    }
  }

  Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.amber;
      case 'low':
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alerts - ${widget.deviceName}')),
      body: FutureBuilder<List<AlertModel>>(
        future: futureAlerts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final alerts = snapshot.data ?? [];

          if (alerts.isEmpty) {
            return const Center(child: Text("No alerts for this device"));
          }

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];

              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.warning,
                    color: _severityColor(alert.severity),
                  ),
                  title: Text(alert.message),
                  subtitle: Text(
                    "${alert.severity.toUpperCase()} — ${alert.createdAt.toLocal()}",
                  ),
                  trailing: alert.resolved
                      ? const Text(
                          "Resolved",
                          style: TextStyle(color: Colors.green),
                        )
                      : AuthService.isAdmin
                      ? TextButton(
                          onPressed: () => _resolveAlert(alert),
                          child: const Text("Resolve"),
                        )
                      : const Text("Open", style: TextStyle(color: Colors.red)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
