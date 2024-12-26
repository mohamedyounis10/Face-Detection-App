import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:faceapp/screens/editimage.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? file;

  Future<void> getImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageCamera = await picker.pickImage(source: ImageSource.camera);
    if (imageCamera != null) {
      file = File(imageCamera.path);
      // Navigate to ImageDisplayScreen and pass the file

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditimageScreen(imageFile: file!),
        ),
      );
    }
  }

  Future<void> getImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageGallery = await picker.pickImage(source: ImageSource.gallery);
    if (imageGallery != null) {
      file = File(imageGallery.path);
      // Navigate to ImageDisplayScreen and pass the file
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditimageScreen(imageFile: file!),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Spacer(), // Pushes content to the center

          // Image
          Center(
            child: Image.asset(
              'assets/images/img.png',
              width: 255,
              height: 260,
              fit: BoxFit.fill,
            ),
          ),

          SizedBox(height: 20),

          // Text
          Text(
            'Face Detection',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          Spacer(), // Pushes content to the center

          // Bottom row of icons
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomIcon(Icons.camera_alt, 'Camera', () async {
                  await getImageCamera();
                }),
                _buildBottomIcon(Icons.photo, 'Gallery', () async {
                  await getImageGallery();
                }),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String label, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[800],
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
