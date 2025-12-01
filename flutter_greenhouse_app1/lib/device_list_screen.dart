import 'package:flutter/material.dart';

import 'services/api_service.dart';
import 'device_detail_screen.dart';
import 'auth_service.dart'; // 👈 pour savoir si c'est admin ou farmer

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

  // petit helper pour recharger la liste si besoin
  void _reloadDevices() {
    setState(() {
      futureDevices = api.getDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devices"),
        actions: [
          // 👇 Bouton + visible seulement si ADMIN
          if (AuthService.isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: ouvrir un écran ou un dialog pour ajouter un device
                // pour l'instant on peut juste mettre un print
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Add device (admin only) - TODO"),
                  ),
                );
              },
            ),
        ],
      ),
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
              final d = devices[index] as Map<String, dynamic>;

              final rawId = d['id'];
              if (rawId == null) {
                return const SizedBox.shrink();
              }
              final int deviceId = rawId is int
                  ? rawId
                  : int.tryParse(rawId.toString()) ?? -1;

              return ListTile(
                title: Text(d["name"]?.toString() ?? "Unnamed device"),
                subtitle: Text(
                  "${d["sensor_type"] ?? "Unknown"} — ${d["status"] ?? ""}",
                ),
                // 👇 On met une row pour ajouter un bouton delete pour admin
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.chevron_right),
                    if (AuthService.isAdmin)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          // TODO: appeler une méthode api.deleteDevice(deviceId)
                          // pour le moment on montre juste un message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Delete device $deviceId (admin only) - TODO",
                              ),
                            ),
                          );
                          // Après implémentation de delete, tu pourras faire :
                          // await api.deleteDevice(deviceId);
                          // _reloadDevices();
                        },
                      ),
                  ],
                ),
                onTap: deviceId == -1
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeviceDetailScreen(
                              deviceId: deviceId,
                              deviceName: d["name"]?.toString() ?? "Device",
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
