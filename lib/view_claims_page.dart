import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'claim_card.dart'; // Import your custom ClaimCard widget
import 'package:connectivity_plus/connectivity_plus.dart';

class ViewClaimsPage extends StatefulWidget {
  const ViewClaimsPage({super.key});

  @override
  State<ViewClaimsPage> createState() => _ViewClaimsPageState();
}

class _ViewClaimsPageState extends State<ViewClaimsPage> {
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Submitted Claims',
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
        stream: FirebaseFirestore.instance
            .collection('claims')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading claims.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No claims submitted yet.'));
          }

          // Notify users when they are offline
          if (!isOnline) {
            return Center(
              child: Text(
                'You are currently offline. Some data may not be up to date.',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var claim = snapshot.data!.docs[index];
              return ClaimCard(
                claimId: claim.id,
                description: claim['description'],
                firstBillDate: claim['firstBillDate'],
                lastBillDate: claim['lastBillDate'],
                ailment: claim['ailment'],
                amount: claim['amount'],
                imageUrl: claim['imageUrl'],
                onEdit: () => _editClaim(claim.id, claim.data() as Map<String, dynamic>),
                onDelete: () => _deleteClaim(claim.id),
              );
            },
          );
        },
      ),
    );
  }

  // Edit claim function
  Future<void> _editClaim(
      String claimId, Map<String, dynamic> claimData) async {
    TextEditingController descriptionController =
    TextEditingController(text: claimData['description']);
    TextEditingController firstBillDateController =
    TextEditingController(text: claimData['firstBillDate']);
    TextEditingController lastBillDateController =
    TextEditingController(text: claimData['lastBillDate']);
    TextEditingController amountController =
    TextEditingController(text: claimData['amount'].toString());

    // Define a list of ailments
    List<String> ailments = [
      'Headache',
      'Fever',
      'Cough',
      'Stomach Ache',
      'Other',
      // Add more ailments as needed
    ];

    String? selectedAilment = claimData['ailment']; // Set the currently selected ailment

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Claim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: firstBillDateController,
                decoration: InputDecoration(labelText: 'First Bill Date'),
              ),
              TextField(
                controller: lastBillDateController,
                decoration: InputDecoration(labelText: 'Last Bill Date'),
              ),
              DropdownButtonFormField<String>(
                value: selectedAilment,
                decoration: InputDecoration(labelText: 'Ailment'),
                items: ailments.map((String ailment) {
                  return DropdownMenuItem<String>(
                    value: ailment,
                    child: Text(ailment),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAilment = newValue;
                  });
                },
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Update the claim in Firestore
                await FirebaseFirestore.instance
                    .collection('claims')
                    .doc(claimId)
                    .update({
                  'description': descriptionController.text,
                  'firstBillDate': firstBillDateController.text,
                  'lastBillDate': lastBillDateController.text,
                  'ailment': selectedAilment, // Use the selected ailment
                  'amount': double.parse(amountController.text),
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }


  // Delete claim function
  Future<void> _deleteClaim(String claimId) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this claim?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await FirebaseFirestore.instance
          .collection('claims')
          .doc(claimId)
          .delete();
    }
  }
}
