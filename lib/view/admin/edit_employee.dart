import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEmployeePage extends StatefulWidget {
  final String employeeId;

  EditEmployeePage({required this.employeeId});

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  String? selectedDepartment;

  @override
  void initState() {
    super.initState();
    getEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
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
              decoration: InputDecoration(labelText: 'Position'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                editEmployee();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                deleteEmployee();
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void getEmployeeData() async {
    try {
      DocumentSnapshot employeeSnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.employeeId)
          .get();

      
      if (employeeSnapshot.exists) {
        Map<String, dynamic> employeeData = employeeSnapshot.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = employeeData['name'];
          selectedDepartment = employeeData['departement'];
          positionController.text = employeeData['position'];
        });
      }
    } catch (error) {
      print('Error retrieving employee data: $error');
    }
  }

  void editEmployee() {
    String name = nameController.text;
    String position = positionController.text;

    FirebaseFirestore.instance.collection('employees').doc(widget.employeeId).update({
      'name': name,
      'departement': selectedDepartment,
      'position': position,
    });
  }

  void deleteEmployee() {
    FirebaseFirestore.instance.collection('employees').doc(widget.employeeId).delete();
  }
}
