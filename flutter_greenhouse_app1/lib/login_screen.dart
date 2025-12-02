import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
<<<<<<< HEAD

import 'auth_service.dart';
=======
import 'services/auth_service.dart';
>>>>>>> b8df76b (final version)
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

<<<<<<< HEAD
  // adapte si besoin (10.0.2.2 si émulateur Android)
  final String baseUrl = 'http://127.0.0.1:8000';
=======
  // URL du backend (modifier selon plateforme)
  final String baseUrl = 'http://127.0.0.1:8000'; // Android: 10.0.2.2
>>>>>>> b8df76b (final version)

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final url = Uri.parse('$baseUrl/api/auth/token/');

    try {
<<<<<<< HEAD
      // 1) Demander le token JWT
=======
      // 1) Récupérer le token JWT
>>>>>>> b8df76b (final version)
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

<<<<<<< HEAD
=======
      print('Réponse login: ${response.statusCode} ${response.body}');

>>>>>>> b8df76b (final version)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access'] as String;

<<<<<<< HEAD
        // On stocke le token pour les appels API
        AuthService.setToken(accessToken);
=======
        // ⚡ Stocker les tokens avant toute utilisation
        AuthService.setToken(accessToken);
        print('Token stocké: ${AuthService.token}');
>>>>>>> b8df76b (final version)

        // 2) Récupérer les rôles de l'utilisateur (/auth/me/)
        final meResponse = await http.get(
          Uri.parse('$baseUrl/api/auth/me/'),
          headers: {
<<<<<<< HEAD
            'Authorization': 'Bearer $accessToken',
=======
            'Authorization': 'Bearer ${AuthService.token}',
>>>>>>> b8df76b (final version)
            'Content-Type': 'application/json',
          },
        );

        if (meResponse.statusCode == 200) {
          final meData = jsonDecode(meResponse.body) as Map<String, dynamic>;
          final rolesDynamic = meData['roles'];
<<<<<<< HEAD

          // rôles = ["admin", "farmer", ...] ou []
          if (rolesDynamic is List) {
            final roles = rolesDynamic.map((e) => e.toString()).toList();
            AuthService.setRoles(roles);
          }
        } else {
          // si /me/ échoue, on continue quand même, mais sans rôles
=======
          if (rolesDynamic is List) {
            AuthService.setRoles(
              rolesDynamic.map((e) => e.toString()).toList(),
            );
          }
        } else {
>>>>>>> b8df76b (final version)
          debugPrint(
            'Erreur /auth/me/ (${meResponse.statusCode}): ${meResponse.body}',
          );
        }

<<<<<<< HEAD
        // 3) Aller vers la liste des devices
=======
        // 3) Naviguer vers DeviceListScreen
>>>>>>> b8df76b (final version)
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
<<<<<<< HEAD
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Se connecter'),
                  ),
=======
            SizedBox(
              width: double.infinity,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Se connecter'),
                    ),
            ),
>>>>>>> b8df76b (final version)
          ],
        ),
      ),
    );
  }
}
