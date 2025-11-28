class Telemetry {
  final int? id; // peut être null si message WebSocket
  final int deviceId; // 🔥 nécessaire pour WebSocket
  final double value;
  final DateTime timestamp;

  Telemetry({
    this.id,
    required this.deviceId,
    required this.value,
    required this.timestamp,
  });

  factory Telemetry.fromJson(Map<String, dynamic> json) {
    return Telemetry(
      id: json['id'], // REST API envoie id
      deviceId: json['device'], // WebSocket ET API
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
