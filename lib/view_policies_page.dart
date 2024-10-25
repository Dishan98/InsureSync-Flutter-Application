import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'policy_card.dart';

class ViewPoliciesPage extends StatelessWidget {
  const ViewPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Policies',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('policies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No policies found.'));
          }

          final policies = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: policies.length,
            itemBuilder: (context, index) {
              var policy = policies[index];
              return PolicyCard(
                policyName: policy['policyName'] ?? 'N/A',
                policyNumber: policy['policyNumber'] ?? 'N/A',
                policyDetails: policy['policyDetails'] ?? 'N/A',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(policy['policyName'] ?? 'N/A'),
                      content: Text(
                        'Policy Details\n\n'
                            'Number: ${policy['policyNumber'] ?? 'N/A'}\n'
                            'Details: ${policy['policyDetails'] ?? 'N/A'}\n',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
