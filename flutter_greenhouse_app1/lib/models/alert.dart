class AlertModel {
  final int id;
  final int deviceId;
  final String severity;
  final String message;
  final bool resolved;
  final DateTime createdAt;

  AlertModel({
    required this.id,
    required this.deviceId,
    required this.severity,
    required this.message,
    required this.resolved,
    required this.createdAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as int,
      deviceId: json['device'] as int,
      severity: json['severity']?.toString() ?? 'info',
      message: json['message']?.toString() ?? '',
      resolved: json['resolved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
