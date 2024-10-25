import 'package:cloud_firestore/cloud_firestore.dart';

class PolicyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPolicy(Map<String, dynamic> policyData) async {
    await _firestore.collection('policies').add(policyData);
  }

  Stream<QuerySnapshot> fetchPolicies() {
    return _firestore.collection('policies').snapshots();
  }
}
