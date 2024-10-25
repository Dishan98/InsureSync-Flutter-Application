import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraUtil {
  final ImagePicker _picker = ImagePicker();

  Future<void> takePicture(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Picture taken: ${image.name}'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No picture selected.'),
      ));
    }
  }
}
