import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomProfileImagePicker extends StatefulWidget {
  final void Function(XFile? image) onImagePicked;
  final XFile? initialImage;

  const CustomProfileImagePicker({
    Key? key,
    required this.onImagePicked,
    this.initialImage,
  }) : super(key: key);

  @override
  State<CustomProfileImagePicker> createState() =>
      _CustomProfileImagePickerState();
}

class _CustomProfileImagePickerState extends State<CustomProfileImagePicker> {
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Inicializa o widget com a imagem inicial, se fornecida
    _selectedImage = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
        widget.onImagePicked(pickedFile);
      }
    } catch (e) {
      print("Erro ao selecionar imagem: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: _selectedImage != null
            ? FileImage(File(_selectedImage!.path))
            : null,
        child: _selectedImage == null ? Icon(Icons.camera_alt, size: 60) : null,
      ),
    );
  }
}
