import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama/uyeol.dart';
import 'services/authService.dart';

class GirisYap extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create an instance of AuthService
  final AuthService _authService = AuthService();

  GirisYap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir e-mail girin';
                      }
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
                        // Call signIn method from AuthService
                        _authService.signIn(
                          context,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        if (kDebugMode) {
                          print('E-mail: ${_emailController.text}');
                        }
                        if (kDebugMode) {
                          print('Şifre: ${_passwordController.text}');
                        }
                      }
                    },
                    child: const Text(
                      'Giriş Yap',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text("Hesabınız yok mu? Üye olun."),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                _onUyeOlButtonClick(context);
              },
              child: const Text(
                'Üye Ol',
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUyeOlButtonClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UyeOl()),
    );
    if (kDebugMode) {
      print("Üye ol butonuna tıklandı");
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: Builder(
      builder: (context) => GirisYap(),
    ),
  ));
}
