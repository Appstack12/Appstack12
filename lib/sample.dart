


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter_plus/tflite_flutter_plus.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Image Capture and Recognition'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _captureAndProcessImage,
          child: Text('Capture Image'),
        ),
      ),
    );
  }

  Future<void> _captureAndProcessImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      await _processImage(pickedImage.path);
    }
  }

  Future<void> _processImage(String imagePath) async {
    // Load the TensorFlow Lite model from the assets
    final interpreter = await Interpreter.fromAsset('assets/your_food_model.tflite');

    // Read the input image bytes
    final inputBytes = File(imagePath).readAsBytesSync();

    // Modify the input shape and data type based on your model's requirements
    final inputShape = interpreter.getInputTensor(0).shape;
    final dataType = interpreter.getInputTensor(0);
    final inputs = [inputBytes.buffer.asUint8List()];

    // Resize the input tensor if needed
    if (inputShape != null) {
      interpreter.resizeInputTensor(0, inputShape);
    }

    // Run the inference
    // interpreter.run(inputs);

    // Get the output tensor
    final outputTensor = interpreter.getOutputTensor(0);

    // Access the output data based on your model's output tensor properties
    // For example, if it's a classification model, you might get the labels and scores
    final labels = await File('assets/your_labels.txt').readAsString();
    // final outputData = outputTensor.getData<Float32List>().toList();

  
    bool isValidImage = false;
    // ...

 
    if (isValidImage) {
     
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Image Recognition Result'),
          content: Text('Image contains food, juice, or snacks.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Invalid Image
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Image Recognition Result'),
          content: Text('Invalid Image.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    // Close the interpreter to release resources
    interpreter.close();
  }
}