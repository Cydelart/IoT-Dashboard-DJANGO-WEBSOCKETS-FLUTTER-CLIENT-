import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/field.dart';

class ApiService {
  Future<List<FieldModel>> fetchFields() async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/fields/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => FieldModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load fields');
    }
  }
}
