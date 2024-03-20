import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VedioPlayer extends StatefulWidget {
  const VedioPlayer({super.key});

  @override
  State<VedioPlayer> createState() => _VedioPlayerState();
}

class _VedioPlayerState extends State<VedioPlayer> {
  List<File> _images = [];
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _pickImage(ImageSource.camera);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
