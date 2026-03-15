import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/utils/responsive_layout.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';
import 'package:image_picker/image_picker.dart';

class EditProductResult {
  const EditProductResult({required this.product, required this.newImage});

  final EditableProductEntity product;
  final File? newImage;
}

class EditProductSheet extends StatefulWidget {
  const EditProductSheet({
    super.key,
    required this.product,
  });

  final EditableProductEntity product;

  @override
  State<EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<EditProductSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _expirationController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _unitAmountController;

  late bool _isFeatured;
  late bool _isOrganic;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product.name);
    _codeController = TextEditingController(text: product.code);
    _descriptionController = TextEditingController(text: product.description);
    _priceController = TextEditingController(text: product.price.toString());
    _expirationController =
        TextEditingController(text: product.expirationsMonths.toString());
    _caloriesController =
        TextEditingController(text: product.numberOfCalories.toString());
    _unitAmountController =
        TextEditingController(text: product.unitAmount.toString());
    _isFeatured = product.isFeatured;
    _isOrganic = product.isOrganic;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _expirationController.dispose();
    _caloriesController.dispose();
    _unitAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContent(
      maxWidth: 720,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final imagePreview = ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: _pickedImage != null
                          ? Image.file(_pickedImage!, fit: BoxFit.cover)
                          : widget.product.imageUrl.isEmpty
                              ? const ColoredBox(
                                  color: Color(0xFFF4F4F4),
                                  child:
                                      Icon(Icons.image_not_supported_outlined),
                                )
                              : Image.network(
                                  widget.product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  );

                  final changeImageButton = OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Change Image'),
                  );

                  if (constraints.maxWidth < 360) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imagePreview,
                        const SizedBox(height: 10),
                        changeImageButton,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      imagePreview,
                      const SizedBox(width: 10),
                      changeImageButton,
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(_nameController, 'Name'),
              const SizedBox(height: 8),
              _buildTextField(_codeController, 'Code'),
              const SizedBox(height: 8),
              _buildTextField(_descriptionController, 'Description',
                  maxLines: 2),
              const SizedBox(height: 8),
              _buildTextField(
                _priceController,
                'Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 420) {
                    return Column(
                      children: [
                        _buildTextField(
                          _expirationController,
                          'Exp Months',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          _caloriesController,
                          'Calories',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          _expirationController,
                          'Exp Months',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          _caloriesController,
                          'Calories',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildTextField(
                _unitAmountController,
                'Unit Amount',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Featured'),
                value: _isFeatured,
                onChanged: (value) => setState(() => _isFeatured = value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Organic'),
                value: _isOrganic,
                onChanged: (value) => setState(() => _isOrganic = value),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      _pickedImage = File(image.path);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updated = widget.product.copyWith(
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      description: _descriptionController.text.trim(),
      price:
          double.tryParse(_priceController.text.trim()) ?? widget.product.price,
      expirationsMonths: int.tryParse(_expirationController.text.trim()) ??
          widget.product.expirationsMonths,
      numberOfCalories: int.tryParse(_caloriesController.text.trim()) ??
          widget.product.numberOfCalories,
      unitAmount: int.tryParse(_unitAmountController.text.trim()) ??
          widget.product.unitAmount,
      isFeatured: _isFeatured,
      isOrganic: _isOrganic,
    );

    Navigator.pop(
      context,
      EditProductResult(product: updated, newImage: _pickedImage),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
