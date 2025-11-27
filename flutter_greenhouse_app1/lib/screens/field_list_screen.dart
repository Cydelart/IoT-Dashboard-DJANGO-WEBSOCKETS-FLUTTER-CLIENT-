import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/field_provider.dart';

class FieldListScreen extends StatefulWidget {
  const FieldListScreen({super.key});

  @override
  State<FieldListScreen> createState() => _FieldListScreenState();
}

class _FieldListScreenState extends State<FieldListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FieldProvider>(context, listen: false).loadFields();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FieldProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Fields")),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.fields.length,
              itemBuilder: (_, index) {
                final f = provider.fields[index];
                return ListTile(
                  title: Text(f.name),
                  subtitle: Text(f.cropType ?? "No crop type"),
                );
              },
            ),
    );
  }
}
