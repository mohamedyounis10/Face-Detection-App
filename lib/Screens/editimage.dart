import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:gallery_saver/gallery_saver.dart';

class EditimageScreen extends StatefulWidget {
  final File imageFile;

  const EditimageScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _EditimageScreenState createState() => _EditimageScreenState();
}

class _EditimageScreenState extends State<EditimageScreen> {
  late File _imageFile; // To hold the image file that will be displayed
  late File _originalImageFile; // To hold the original image file

  @override
  void initState() {
    super.initState();
    _imageFile = widget.imageFile; // Initialize with the passed image
    _originalImageFile = widget.imageFile; // Store the original image
  }

  // Function to upload image and get processed result
  Future<void> _uploadImageAndDetectFace(BuildContext context) async {
    // Replace with your server's URL
    final uri = Uri.parse('http://192.168.1.7:5000/upload');

    // Create a multipart request
    final request = http.MultipartRequest('POST', uri);
    final file = await http.MultipartFile.fromPath(
      'file',
      _imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    );

    request.files.add(file);

    try {
      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        // Handle success: show a message or process the returned image
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Face detection successful!')),
        );

        // Process and display the image if needed
        final imageBytes = await response.stream.toBytes();
        final tempFile = File('${(await Directory.systemTemp).path}/output.jpg');
        await tempFile.writeAsBytes(imageBytes);

        // Update the state to display the processed image
        setState(() {
          _imageFile = tempFile;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to detect faces')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  // Undo functionality to restore the original image
  void _undoChanges() {
    setState(() {
      _imageFile = _originalImageFile; // Revert to the original image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Selected Image',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // Save the image to the gallery
              final result = await GallerySaver.saveImage(_imageFile.path);
              if (result != null && result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Image saved to gallery!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save image.')),
                );
              }
            },
            icon: Icon(Icons.save, color: Colors.white, size: 25),
          ),
          IconButton(
            onPressed: _undoChanges, // Call undo function on press
            icon: Icon(Icons.undo, color: Colors.white, size: 25),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 360,
              height: 432,
              child: Center(
                child: Image.file(
                  _imageFile, // Display the current image (original or processed)
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  'Apply',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomFilter(
                          'assets/images/img2.jpg', 'Face Detection', () {
                        _uploadImageAndDetectFace(context);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomFilter(
      String imagePath, String label, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
