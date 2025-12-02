class Telemetry {
  final int? id; // id de la télémétrie (peut être null)
  final int? deviceId; // id du device (peut être null si problème backend)
  final double value;
  final DateTime timestamp;
  final bool processedByRule;

  Telemetry({
    this.id,
    this.deviceId,
    required this.value,
    required this.timestamp,
    required this.processedByRule,
  });

  factory Telemetry.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return Telemetry(
<<<<<<< HEAD
      id: json['id'], // REST API envoie id
      deviceId: json['device'], // WebSocket ET API
=======
      id: toInt(json['id']),
      deviceId: toInt(json['device_id'] ?? json['device']),
>>>>>>> b8df76b (final version)
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      processedByRule: json['processed_by_rule'] as bool? ?? false,
    );
  }
}
