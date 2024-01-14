import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'services/authService.dart';

class UyeOl extends StatefulWidget {
  const UyeOl({super.key});

  @override
  UyeOlState createState() => UyeOlState();
}

class UyeOlState extends State<UyeOl> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create an instance of AuthService
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üye Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ad Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adınızı ve soyadınızı girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir e-mail girin';
                  }
                  // E-mail format kontrolü ekleyebilirsiniz.
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir şifre girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Call registerUser function from AuthService
                    _authService.signUp(
                      context,
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (kDebugMode) {
                      print('Ad Soyad: ${_nameController.text}');
                    }
                    if (kDebugMode) {
                      print('E-mail: ${_emailController.text}');
                    }
                    if (kDebugMode) {
                      print('Şifre: ${_passwordController.text}');
                    }
                  }
                },
                child: const Text('Üye Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UyeOl(),
  ));
}
