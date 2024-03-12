import 'dart:io';

import 'package:fit_for_life/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final userService = UserService();

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onPickImage,
    required this.isLoading,
    required this.image,
  });

  final void Function(String pickedImage) onPickImage;
  final void Function(bool loading) isLoading;
  final String image;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.isLoading(true);

    final res = await userService.uploadImage(pickedImage.path);
    if (res['status']) {
      widget.onPickImage(res['data'] ?? '');
    }

    widget.isLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: widget.image.isNotEmpty
              ? CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                    widget.image,
                  ),
                )
              : _pickedImageFile != null
                  ? CircleAvatar(
                      radius: 48,
                      child: CircleAvatar(
                        radius: 96,
                        backgroundImage: Image.file(
                          _pickedImageFile!,
                          fit: BoxFit.cover,
                        ).image,
                      ),
                    )
                  : Image.asset(
                      'assets/images/profile.png',
                      height: 96,
                      width: 96,
                    ),
        ),
      ],
    );
  }
}
