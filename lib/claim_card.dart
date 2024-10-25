import 'package:flutter/material.dart';

class ClaimCard extends StatelessWidget {
  final String claimId;
  final String description;
  final String firstBillDate;
  final String lastBillDate;
  final String ailment;
  final double amount;
  final String? imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClaimCard({
    super.key,
    required this.claimId,
    required this.description,
    required this.firstBillDate,
    required this.lastBillDate,
    required this.ailment,
    required this.amount,
    this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ailment: $ailment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'First Bill Date: $firstBillDate',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Last Bill Date: $lastBillDate',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Amount: LKR ${amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            // Display the image if the URL exists
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Container(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: double.infinity,
                ),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit),
                  color: Colors.blue,
                  tooltip: 'Edit Claim',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  tooltip: 'Delete Claim',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
