import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'services/api_service.dart';
import 'device_detail_screen.dart';
import 'auth_service.dart'; // 👈 pour savoir si c'est admin ou farmer
=======
import 'services/api_service.dart';
import 'device_detail_screen.dart';
import 'services/auth_service.dart';
>>>>>>> b8df76b (final version)

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

<<<<<<< HEAD
  // petit helper pour recharger la liste si besoin
=======
>>>>>>> b8df76b (final version)
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
<<<<<<< HEAD
          // 👇 Bouton + visible seulement si ADMIN
=======
>>>>>>> b8df76b (final version)
          if (AuthService.isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
<<<<<<< HEAD
                // TODO: ouvrir un écran ou un dialog pour ajouter un device
                // pour l'instant on peut juste mettre un print
=======
>>>>>>> b8df76b (final version)
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
<<<<<<< HEAD
              if (rawId == null) {
                return const SizedBox.shrink();
              }
=======
              if (rawId == null) return const SizedBox.shrink();

>>>>>>> b8df76b (final version)
              final int deviceId = rawId is int
                  ? rawId
                  : int.tryParse(rawId.toString()) ?? -1;

              return ListTile(
                title: Text(d["name"]?.toString() ?? "Unnamed device"),
                subtitle: Text(
                  "${d["sensor_type"] ?? "Unknown"} — ${d["status"] ?? ""}",
                ),
<<<<<<< HEAD
                // 👇 On met une row pour ajouter un bouton delete pour admin
=======
>>>>>>> b8df76b (final version)
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.chevron_right),
                    if (AuthService.isAdmin)
                      IconButton(
                        icon: const Icon(Icons.delete),
<<<<<<< HEAD
                        onPressed: () async {
                          // TODO: appeler une méthode api.deleteDevice(deviceId)
                          // pour le moment on montre juste un message
=======
                        onPressed: () {
>>>>>>> b8df76b (final version)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Delete device $deviceId (admin only) - TODO",
                              ),
                            ),
                          );
<<<<<<< HEAD
                          // Après implémentation de delete, tu pourras faire :
                          // await api.deleteDevice(deviceId);
                          // _reloadDevices();
=======
>>>>>>> b8df76b (final version)
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
<<<<<<< HEAD
                            builder: (context) => DeviceDetailScreen(
=======
                            builder: (_) => DeviceDetailScreen(
>>>>>>> b8df76b (final version)
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
