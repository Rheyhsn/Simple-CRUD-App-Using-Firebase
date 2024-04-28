import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController nipController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  String? selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Karyawan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nipController,
              decoration: InputDecoration(labelText: 'NIP'),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: tanggalLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('departements').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                List<DropdownMenuItem> departmentItems = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DocumentSnapshot snap = snapshot.data!.docs[i];
                  departmentItems.add(
                    DropdownMenuItem(
                      child: Text(
                        snap['name'],
                      ),
                      value: "${snap['name']}",
                    ),
                  );
                }
                return DropdownButtonFormField(
                  value: selectedDepartment,
                  items: departmentItems,
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value.toString();
                    });
                  },
                  decoration: InputDecoration(labelText: 'Departemen'),
                );
              },
            ),
            TextField(
              controller: positionController,
              decoration: InputDecoration(labelText: 'Posisi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addEmployee();
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void addEmployee() {
    String nip = nipController.text;
    String name = nameController.text;
    String tanggalLahir = tanggalLahirController.text;
    String position = positionController.text;

    FirebaseFirestore.instance.collection('employees').add({
      'nip': nip,
      'name': name,
      'position': position,
      'tanggal_lahir': tanggalLahir,
      'departement': selectedDepartment,
    });
  }
}
