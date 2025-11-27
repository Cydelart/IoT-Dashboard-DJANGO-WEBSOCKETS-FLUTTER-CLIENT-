import 'package:flutter/foundation.dart';
import '../models/field.dart';
import '../services/api_service.dart';

class FieldProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  List<FieldModel> fields = [];
  bool loading = false;

  Future<void> loadFields() async {
    loading = true;
    notifyListeners();

    fields = await api.fetchFields();

    loading = false;
    notifyListeners();
  }
}
