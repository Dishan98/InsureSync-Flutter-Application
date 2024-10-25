import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PolicyForm extends StatefulWidget {
  const PolicyForm({super.key});

  @override
  _PolicyFormState createState() => _PolicyFormState();
}

class _PolicyFormState extends State<PolicyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _policyNameController = TextEditingController();
  final TextEditingController _policyNumberController = TextEditingController();
  final TextEditingController _policyDetailsController = TextEditingController();

  Future<void> _submitPolicy() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Add new policy data to Firestore
        await FirebaseFirestore.instance.collection('policies').add({
          'policyName': _policyNameController.text,
          'policyNumber': _policyNumberController.text,
          'policyDetails': _policyDetailsController.text,
          'createdAt': Timestamp.now(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Policy submitted successfully!')),
        );

        // Clear form fields after submission
        _policyNameController.clear();
        _policyNumberController.clear();
        _policyDetailsController.clear();
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit policy: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'File a New Policy',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Allows scrolling for smaller screens
            child: Column(
              children: [
                TextFormField(
                  controller: _policyNameController,
                  decoration: InputDecoration(
                    labelText: 'Policy Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    prefixIcon: Icon(Icons.assignment), // Icon in the text field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a policy name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _policyNumberController,
                  decoration: InputDecoration(
                    labelText: 'Policy Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    prefixIcon: Icon(Icons.confirmation_number), // Icon in the text field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a policy number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _policyDetailsController,
                  decoration: InputDecoration(
                    labelText: 'Policy Details',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    prefixIcon: Icon(Icons.description), // Icon in the text field
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide details for the policy';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitPolicy,
                  child: Text('Submit Policy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Button color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _policyNameController.dispose();
    _policyNumberController.dispose();
    _policyDetailsController.dispose();
    super.dispose();
  }
}
