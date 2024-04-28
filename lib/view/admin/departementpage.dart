import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartementPage extends StatefulWidget {
  @override
  _DepartementPageState createState() => _DepartementPageState();
}

class _DepartementPageState extends State<DepartementPage> {
  final TextEditingController departementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Departemen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: departementController,
              decoration: InputDecoration(labelText: 'Departemen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addDepartement();
              },
              child: Text('Tambah Departemen'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('departements').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final departementDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: departementDocs.length,
                    itemBuilder: (context, index) {
                      final departement = departementDocs[index];
                      return ListTile(
                        title: Text(departement['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteDepartement(departement.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addDepartement() {
    String departementName = departementController.text;
    FirebaseFirestore.instance.collection('departements').add({'name': departementName});
    departementController.clear();
  }

  void deleteDepartement(String departementId) {
    FirebaseFirestore.instance.collection('departements').doc(departementId).delete();
  }
}
