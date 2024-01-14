import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobil_uygulama/isteklistesi.dart';
import 'package:mobil_uygulama/favoriurunlistesi.dart';
import 'package:mobil_uygulama/profilduzenle.dart';
import 'package:mobil_uygulama/main.dart';
import 'package:mobil_uygulama/services/authService.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  Future<bool> _isAdmin = Future<bool>.value(false);
  late Future<Map<String, dynamic>?> _userInfo;

  @override
  void initState() {
    super.initState();
    _updateAdminStatus();
    _userInfo = _authService.getCurrentUserInfo();
  }

  Future<void> _updateAdminStatus() async {
    _isAdmin = _authService.isAdmin();
    setState(() {});
  }

  Future<void> _updateUser() async {
    setState(() {
      _userInfo = _authService.getCurrentUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          User? user = _auth.currentUser;
          if (user != null) {
            return Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50.0),
                  FutureBuilder<bool>(
                    future: _isAdmin,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Hata: ${snapshot.error}');
                      } else {
                        bool isAdmin = snapshot.data ?? false;
                        if (!isAdmin) {
                          return ElevatedButton(
                            onPressed: () {
                              // İstek listesi sayfasına geçiş yap
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilDuzenle(userInfo: _userInfo),
                                ),
                              ).then((_) {
                                _updateUser();
                              });;
                            },
                            child: const Text(
                              'Profil Düzenle',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink(); // Boş SizedBox, admin ise gösterme
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 30.0),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _userInfo,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Hata: ${snapshot.error}');
                      } else {
                        Map<String, dynamic>? userInfo = snapshot.data;
                        String userName = userInfo?["name"] ?? "Belirtilmemiş";
                        return Text(
                          'İsim Soyisim: $userName',
                          style: const TextStyle(fontSize: 20),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'E-mail: ${user.email ?? "Belirtilmemiş"}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 50.0),
                  FutureBuilder<bool>(
                    future: _isAdmin,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Hata: ${snapshot.error}');
                      } else {
                        bool isAdmin = snapshot.data ?? false;
                        if (!isAdmin) {
                          return ElevatedButton(
                            onPressed: () {
                              // Favori ürün listesi sayfasına geçiş yap
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FavoriUrunListesi(),
                                ),
                              );
                            },
                            child: const Text(
                              'Favori Ürün Listesi',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink(); // Boş SizedBox, admin ise gösterme
                        }
                      }
                    },
                  ),
                  FutureBuilder<bool>(
                    future: _isAdmin,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Hata: ${snapshot.error}');
                      } else {
                        bool isAdmin = snapshot.data ?? false;
                        if (!isAdmin) {
                          return ElevatedButton(
                            onPressed: () {
                              // İstek listesi sayfasına geçiş yap
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const IstekListesi(),
                                ),
                              );
                            },
                            child: const Text(
                              'İstek Listesi',
                              style: TextStyle(
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink(); // Boş SizedBox, admin ise gösterme
                        }
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GirisKontrol()),
                      );
                    },
                    child: const Text(
                      'Çıkış Yap',
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Kullanıcı bulunamadı',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Profil(),
  ));
}
