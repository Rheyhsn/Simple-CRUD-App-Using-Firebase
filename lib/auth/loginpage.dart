import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Dapatkan informasi pengguna yang telah login
      User? user = userCredential.user;

      // Periksa peran pengguna di Firestore
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        dynamic userData = snapshot.data();
        if (userData is Map<String, dynamic>) {
          String role = userData['role'];

          // Navigasi ke halaman sesuai dengan peran pengguna
          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin_home');
          } else if (role == 'user') {
            Navigator.pushReplacementNamed(context, '/user_home');
          } else {
            // Peran tidak valid
            print('Peran tidak valid.');
          }
        } else {
          // Data pengguna tidak ditemukan di Firestore atau tidak sesuai dengan tipe yang diharapkan
          print('Data pengguna tidak ditemukan di Firestore atau tidak sesuai dengan tipe yang diharapkan.');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('User tidak ditemukan.');
      } else if (e.code == 'wrong-password') {
        print('Password salah.');
      }
      // Tampilkan pesan error kepada pengguna
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login gagal. Periksa email dan password Anda.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigasi ke halaman pendaftaran akun
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
