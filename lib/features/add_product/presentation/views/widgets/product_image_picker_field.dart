import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductImagePickerField extends StatefulWidget {
  const ProductImagePickerField({
    super.key,
    required this.onFileChanged,
  });

  final ValueChanged<File?> onFileChanged;

  @override
  State<ProductImagePickerField> createState() =>
      _ProductImagePickerFieldState();
}

class _ProductImagePickerFieldState extends State<ProductImagePickerField> {
  bool _isLoading = false;
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _isLoading,
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(_selectedImage!),
                    )
                  : const Icon(
                      Icons.image_outlined,
                      size: 180,
                    ),
            ),
            if (_selectedImage != null)
              IconButton(
                onPressed: _removeImage,
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      setState(() => _selectedImage = File(image.path));
      widget.onFileChanged(_selectedImage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _removeImage() {
    setState(() => _selectedImage = null);
    widget.onFileChanged(null);
  }
}
