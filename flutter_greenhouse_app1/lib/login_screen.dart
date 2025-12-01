import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'device_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  // adapte si besoin (10.0.2.2 si émulateur Android)
  final String baseUrl = 'http://127.0.0.1:8000';

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final url = Uri.parse('$baseUrl/api/auth/token/');

    try {
      // 1) Demander le token JWT
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access'] as String;

        // On stocke le token pour les appels API
        AuthService.setToken(accessToken);

        // 2) Récupérer les rôles de l'utilisateur (/auth/me/)
        final meResponse = await http.get(
          Uri.parse('$baseUrl/api/auth/me/'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );

        if (meResponse.statusCode == 200) {
          final meData = jsonDecode(meResponse.body) as Map<String, dynamic>;
          final rolesDynamic = meData['roles'];

          // rôles = ["admin", "farmer", ...] ou []
          if (rolesDynamic is List) {
            final roles = rolesDynamic.map((e) => e.toString()).toList();
            AuthService.setRoles(roles);
          }
        } else {
          // si /me/ échoue, on continue quand même, mais sans rôles
          debugPrint(
            'Erreur /auth/me/ (${meResponse.statusCode}): ${meResponse.body}',
          );
        }

        // 3) Aller vers la liste des devices
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DeviceListScreen()),
          );
        }
      } else {
        setState(() {
          _error = 'Identifiants invalides (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur de connexion : $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Se connecter'),
                  ),
          ],
        ),
      ),
    );
  }
}
