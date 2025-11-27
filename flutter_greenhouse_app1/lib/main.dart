import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/field_provider.dart';
import 'screens/field_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FieldProvider())],
      child: MaterialApp(
        title: 'Smart Agriculture',
        home: const FieldListScreen(),
      ),
    );
  }
}
