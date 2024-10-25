import 'package:flutter/material.dart';

class PolicyCard extends StatelessWidget {
  final String policyName;
  final String policyNumber;
  final String policyDetails;
  final VoidCallback onTap;

  const PolicyCard({
    super.key,
    required this.policyName,
    required this.policyNumber,
    required this.policyDetails,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          policyName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Policy Number: $policyNumber',
          style: TextStyle(color: Colors.grey[600]),
        ),
        onTap: onTap,
      ),
    );
  }
}
