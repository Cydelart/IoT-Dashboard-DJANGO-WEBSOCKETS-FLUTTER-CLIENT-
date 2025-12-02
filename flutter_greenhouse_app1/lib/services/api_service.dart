import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/telemetry.dart';
import '../models/alert.dart';
<<<<<<< HEAD
import '../auth_service.dart';
=======
import 'auth_service.dart';
>>>>>>> b8df76b (final version)

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Headers avec Authorization si token dispo
  Map<String, String> _headers({bool jsonContent = true}) {
    final token = AuthService.token;

    final headers = <String, String>{};
    if (jsonContent) {
      headers['Content-Type'] = 'application/json';
    }
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Liste des devices
  Future<List<dynamic>> getDevices() async {
    final url = Uri.parse('$baseUrl/devices/');

    final response = await http.get(url, headers: _headers(jsonContent: false));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded;
      } else {
        throw Exception('Unexpected devices format: ${decoded.runtimeType}');
      }
    } else {
      throw Exception('Failed to load devices (status ${response.statusCode})');
    }
  }

  /// Historique de télémétrie pour un device
  Future<List<Telemetry>> getDeviceTelemetry(int deviceId) async {
    final url = Uri.parse('$baseUrl/devices/$deviceId/telemetry/');

    final response = await http.get(url, headers: _headers(jsonContent: false));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        return decoded
            .map((e) => Telemetry.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // si DRF est configuré avec pagination
      if (decoded is Map && decoded['results'] is List) {
        final list = decoded['results'] as List;
        return list
            .map((e) => Telemetry.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Unexpected telemetry format: ${decoded.runtimeType}');
    } else {
      throw Exception(
        'Failed to load telemetry (status ${response.statusCode})',
      );
    }
  }

  /// Création d’une télémétrie via l’API
  /// Utile pour tester le temps réel depuis Flutter
  Future<Telemetry> createTelemetry({
    required int deviceId,
    required double value,
    required DateTime timestamp,
  }) async {
    final url = Uri.parse('$baseUrl/telemetry/');

    final body = json.encode({
      'device': deviceId,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    });

    final response = await http.post(url, headers: _headers(), body: body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      return Telemetry.fromJson(decoded);
    } else {
      throw Exception(
        'Failed to create telemetry (status ${response.statusCode})',
      );
    }
  }

  /// Liste des alertes d’un device
  Future<List<AlertModel>> getDeviceAlerts(int deviceId) async {
    final url = Uri.parse('$baseUrl/devices/$deviceId/alerts/');

    final response = await http.get(url, headers: _headers(jsonContent: false));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        return decoded
            .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Unexpected alerts format: ${decoded.runtimeType}');
    } else {
      throw Exception('Failed to load alerts (status ${response.statusCode})');
    }
  }

  /// Marquer une alerte comme résolue (admin only)
  Future<void> resolveAlert(int alertId) async {
    final url = Uri.parse('$baseUrl/alerts/$alertId/resolve/');

    final response = await http.post(url, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to resolve alert (status ${response.statusCode})',
      );
    }
  }
}
