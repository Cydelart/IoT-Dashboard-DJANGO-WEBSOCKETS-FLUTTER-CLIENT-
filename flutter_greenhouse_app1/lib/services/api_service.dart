// lib/services/api_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/telemetry.dart';

class ApiService {
  // 👉 If you test on Android emulator, change host to "10.0.2.2:8000"
  static const String _baseUrl = 'http://127.0.0.1:8000';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String path, [Map<String, dynamic>? queryParams]) {
    final uri = Uri.parse('$_baseUrl$path');
    if (queryParams == null) return uri;
    return uri.replace(
      queryParameters: queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  // ───────────────────────────── FIELDS ─────────────────────────────

  /// GET /api/fields/
  /// Returns a List<dynamic> where each element is a JSON map
  Future<List<dynamic>> getFields() async {
    final url = _buildUri('/api/fields/');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load fields (status: ${response.statusCode})');
    }
  }

  // ───────────────────────────── DEVICES ─────────────────────────────

  /// GET /api/devices/
  /// Optionally filter by field: /api/devices/?field=<id>
  Future<List<dynamic>> getDevices({int? fieldId}) async {
    final params = <String, dynamic>{};
    if (fieldId != null) {
      // only if your Django DeviceViewSet supports ?field= filtering
      params['field'] = fieldId;
    }

    final url = _buildUri('/api/devices/', params.isEmpty ? null : params);
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        'Failed to load devices (status: ${response.statusCode})',
      );
    }
  }

  // ───────────────────────────── TELEMETRY ─────────────────────────────

  /// Historical telemetry for one device.
  ///
  /// Version 1 (most common in DRF):
  ///   GET /api/telemetry/?device=<id>
  ///
  /// If you later change your backend to:
  ///   /api/devices/<id>/telemetry/
  /// then just update the `url` variable below.
  Future<List<Telemetry>> getDeviceTelemetry(int deviceId) async {
    // 1) If your TelemetryViewSet uses ?device=<id>:
    final url = _buildUri('/api/telemetry/', {'device': deviceId});

    // 2) If you used a nested route instead, comment the line above and use:
    // final url = _buildUri('/api/devices/$deviceId/telemetry/');

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => Telemetry.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load telemetry (status: ${response.statusCode})',
      );
    }
  }

  // ───────────────────────────── CLEANUP ─────────────────────────────

  void dispose() {
    _client.close();
  }
}
