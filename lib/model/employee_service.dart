import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add new employee
  Future<void> addEmployee(String name, String position) async {
    await _firestore.collection('employees').add({
      'name': name,
      'position': position,
    });
  }

  // Edit employee
  Future<void> editEmployee(String id, String name, String position) async {
    await _firestore.collection('employees').doc(id).update({
      'name': name,
      'position': position,
    });
  }

  // Delete employee
  Future<void> deleteEmployee(String id) async {
    await _firestore.collection('employees').doc(id).delete();
  }

  // Get all employees
  Stream<QuerySnapshot> getAllEmployees() {
    return _firestore.collection('employees').snapshots();
  }
}
