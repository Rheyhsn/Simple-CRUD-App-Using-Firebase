import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late TextEditingController _nameController;
  late String _imageUrl = ''; // Inisialisasi _imageUrl dengan nilai default

  final ImagePicker _imagePicker = ImagePicker(); // Instance dari ImagePicker

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      String userName = userData.get('name');
      String userImageUrl = userData.get('imageUrl'); // Mendapatkan URL gambar profil pengguna

      _nameController.text = userName;
      setState(() {
        _imageUrl = userImageUrl; // Mengatur URL gambar profil untuk ditampilkan
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit your profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: _imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : null, // Menampilkan gambar profil jika tersedia
              child: _imageUrl.isEmpty ? Icon(Icons.person, size: 50) : null, // Icon pengguna jika gambar profil tidak tersedia
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _pickImage, // Memilih gambar dari galeri
              child: Text('Change Photo'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateProfile(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

 Future<void> _pickImage() async {
  final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    setState(() {
      _imageUrl = pickedImage.path; // Mengambil path gambar
    });
  }
}

  Future<void> _updateProfile(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'name': _nameController.text,
        'imageUrl': _imageUrl, // Memperbarui URL gambar profil di Firestore
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully!'),
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update profile. Please try again.'),
      ));
    }
  }
}
