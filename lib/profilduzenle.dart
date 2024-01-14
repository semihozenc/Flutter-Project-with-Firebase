//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/authService.dart';

class ProfilDuzenle extends StatefulWidget {
  final Future<Map<String, dynamic>?> userInfo;

  const ProfilDuzenle({Key? key, required this.userInfo}) : super(key: key);

  @override
  _ProfilDuzenleState createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  void _updateUserInfo() async {
    final userInfo = await widget.userInfo;

    if (userInfo != null) {
      final userId = userInfo["id"];
      final name = _nameController.text;
      final password = _passwordController.text;

      if (userId != null) {
        await _authService.updateUserInfo(
          userId: userId,
          name: name,
          password: password,
        );
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // widget.userInfo ile gelen bilgileri kontrolcülere yerleştir
    widget.userInfo.then((userInfo) {
      if (userInfo != null) {
        _nameController.text = userInfo["name"] ?? "";
        _emailController.text = userInfo["email"] ?? "";
        _passwordController.text = userInfo["password"] ?? "";
        // Şifre kontrolcüsü için işlemleri burada yapabilirsiniz
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'İsim Soyisim'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: false,
              decoration: const InputDecoration(labelText: 'Şifre'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateUserInfo();
                Navigator.pop(context);
              },
              child: const Text('Bilgileri Güncelle'),
            ),
          ],
        ),
      ),
    );
  }
}
