import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobil_uygulama/girisyap.dart';
import 'package:mobil_uygulama/profil.dart';
import 'package:mobil_uygulama/anasayfa.dart';
import 'package:mobil_uygulama/sepet.dart';
import 'package:mobil_uygulama/services/notificationService.dart';
import 'package:mobil_uygulama/urunekle.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotification();

  runApp(MaterialApp(
    home: GirisKontrol(),
  ));
}

class GirisKontrol extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user != null) {
      // Kullanıcı giriş yapmışsa Urunler sayfasını göster
      return Urunler();
    } else {
      // Kullanıcı giriş yapmamışsa Girisyap sayfasına yönlendir
      return GirisYap();
    }
  }
}

class Urunler extends StatefulWidget {
  final int? index;

  const Urunler({super.key, this.index = 0}); // Set a default value of 0


  @override
  State<Urunler> createState() => _UrunlerState(index!);
}

class _UrunlerState extends State<Urunler> {
  int _seciliIndex;
  _UrunlerState(this._seciliIndex);


  void _onItemTapped(int index) {
    setState(() {
      _seciliIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gitti Geliyor'),
      ),
      body: Center(
        child: _sayfaGetir(_seciliIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _buildBottomNavBarItems(user),
        currentIndex: _seciliIndex,
        selectedItemColor: Colors.deepOrangeAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems(User? user) {
    if (user != null && user.email == "admin@admin.com") {
      // Admin kullanıcısı ise farklı BottomNavigationBarItem'lar göster
      return const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Anasayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ürün Ekleme',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profil',
        ),
      ];
    } else {
      // Diğer kullanıcılar için varsayılan BottomNavigationBarItem'lar
      return const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Anasayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Sepet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profil',
        ),
      ];
    }
  }

  Widget _sayfaGetir(int index) {
    User? user = FirebaseAuth.instance.currentUser;
    switch (index) {
      case 0:
        return const Anasayfa();
      case 1:
          if (user != null && user.email == "admin@admin.com") {
            return const UrunEkle();
          } else {
            return const Sepet();
          }
      case 2:
        return const Profil();
      default:
        return Container(); // Yedek, boş bir container veya hata sayfası eklenebilir.
    }
  }
}
