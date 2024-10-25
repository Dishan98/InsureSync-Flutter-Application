import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubmitClaimPage extends StatefulWidget {
  const SubmitClaimPage({super.key});

  @override
  _SubmitClaimPageState createState() => _SubmitClaimPageState();
}

class _SubmitClaimPageState extends State<SubmitClaimPage> {
  final TextEditingController _claimDescriptionController = TextEditingController();
  final TextEditingController _firstBillDateController = TextEditingController();
  final TextEditingController _lastBillDateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _imageUrl;
  double? _uploadProgress;
  String? _selectedAilment;

  final List<String> _ailments = [
    'Headache',
    'Fever',
    'Cough',
    'Stomach Ache',
    'Other',
  ];

  Future<void> _submitClaim() async {
    if (_claimDescriptionController.text.isEmpty ||
        _imageUrl == null ||
        _firstBillDateController.text.isEmpty ||
        _lastBillDateController.text.isEmpty ||
        _selectedAilment == null ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and upload an image.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('claims').add({
        'description': _claimDescriptionController.text,
        'imageUrl': _imageUrl,
        'firstBillDate': _firstBillDateController.text,
        'lastBillDate': _lastBillDateController.text,
        'ailment': _selectedAilment,
        'amount': double.tryParse(_amountController.text) ?? 0.0,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Claim submitted successfully!')),
      );

      _claimDescriptionController.clear();
      _firstBillDateController.clear();
      _lastBillDateController.clear();
      _amountController.clear();
      _selectedAilment = null;
      setState(() {
        _imageUrl = null;
        _uploadProgress = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit claim: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: Text('Select a source for the image.'),
          actions: [
            TextButton(
              onPressed: () async {
                final image = await picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, image);
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                final image = await picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, image);
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (pickedImage != null) {
      await _uploadImage(File(pickedImage.path));
    }
  }

  Future<void> _uploadImage(File image) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('claims/${DateTime.now().millisecondsSinceEpoch}.png');

      UploadTask uploadTask = ref.putFile(image);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      await uploadTask;

      _imageUrl = await ref.getDownloadURL();
      setState(() {
        _uploadProgress = null;
      });

      Fluttertoast.showToast(
        msg: 'Image uploaded successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0x80B0BEC5),
        textColor: Colors.white,
        fontSize: 12.0,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed: $e')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _imageUrl = null;
      _uploadProgress = null;
    });
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Submit Claim',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _firstBillDateController,
                decoration: InputDecoration(
                  labelText: 'First Bill Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(_firstBillDateController),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _lastBillDateController,
                decoration: InputDecoration(
                  labelText: 'Last Bill Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(_lastBillDateController),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedAilment,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAilment = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Ailment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.local_hospital),
                ),
                items: _ailments.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.money),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _claimDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Claim Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Upload Bills'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitClaim,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Submit Claim'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              if (_uploadProgress != null) ...[
                Text('Upload progress: ${(_uploadProgress! * 100).toStringAsFixed(2)}%'),
                SizedBox(height: 10),
                LinearProgressIndicator(value: _uploadProgress),
              ],
              if (_imageUrl != null) ...[
                SizedBox(height: 20),
                // Wrap Image and Remove Icon in a Stack
                Stack(
                  children: [
                    // Image widget with a maxHeight limit
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 300,  // Limiting the image height to make it scrollable
                      ),
                      child: Image.network(_imageUrl!),
                    ),
                    // Positioned cross button in the top-right corner
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _removeImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0x80B0BEC5), // Red background for the icon
                            shape: BoxShape.circle, // Circular shape
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            color: Colors.white, // White cross icon
                          ), // Padding around the icon
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
