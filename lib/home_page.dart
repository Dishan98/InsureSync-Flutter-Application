import 'package:enterprise_mobility_assignment/submit_claim.dart';
import 'package:enterprise_mobility_assignment/view_claims_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showSignOutConfirmation(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Insurance icon above the welcome message
            Center(
              child: Icon(
                Icons.medical_services, // Use a suitable insurance-related icon
                size: 80, // Size of the icon
                color: Colors.blueAccent, // Icon color
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Welcome, ${user?.email?.split('@')[0] ?? 'User'}!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // Grid view for buttons as tiles
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Two tiles per row
                childAspectRatio: 1.2, // Adjust the aspect ratio as needed
                mainAxisSpacing: 20, // Space between rows
                crossAxisSpacing: 20, // Space between columns
                children: [
                  // Tile for filing a new policy
                  _buildTile(
                    context,
                    Icons.assignment,
                    'File a New Policy',
                    Colors.green,
                        () {
                      Navigator.pushNamed(context, '/policyForm');
                    },
                  ),

                  // Tile for viewing existing policies
                  _buildTile(
                    context,
                    Icons.list_alt,
                    'View Policies',
                    Colors.orange,
                        () {
                      Navigator.pushNamed(context, '/viewPolicies');
                    },
                  ),

                  // Tile for submitting a claim
                  _buildTile(
                    context,
                    Icons.file_upload,
                    'Submit a Claim',
                    Colors.blueAccent,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubmitClaimPage()),
                      );
                    },
                  ),

                  // Tile for viewing submitted claims
                  _buildTile(
                    context,
                    Icons.list_alt,
                    'View Submitted Claims',
                    Colors.teal,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewClaimsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a tile
  Widget _buildTile(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
