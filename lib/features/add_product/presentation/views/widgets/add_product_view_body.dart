import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/utils/responsive_layout.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_button.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_text_field.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/manager/cubit/add_product_cubit.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/models/add_product_form_data.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/views/widgets/product_image_picker_field.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/views/widgets/product_option_toggle.dart';

class AddProductViewBody extends StatefulWidget {
  const AddProductViewBody({super.key});

  @override
  State<AddProductViewBody> createState() => _AddProductViewBodyState();
}

class _AddProductViewBodyState extends State<AddProductViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? _name;
  String? _code;
  String? _description;
  num? _price;
  num? _expirationMonths;
  num? _numberOfCalories;
  num? _unitAmount;
  File? _selectedImage;
  bool _isFeatured = false;
  bool _isOrganic = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContent(
      maxWidth: 760,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            children: [
              CustomTextFormField(
                hintText: 'Product Name',
                textInputType: TextInputType.text,
                onSaved: (value) => _name = value?.trim(),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Product Price',
                textInputType: TextInputType.number,
                onSaved: (value) => _price = num.parse(value!),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Expiration Months',
                textInputType: TextInputType.number,
                onSaved: (value) => _expirationMonths = num.parse(value!),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Number Of Calories',
                textInputType: TextInputType.number,
                onSaved: (value) => _numberOfCalories = num.parse(value!),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Unit Amount',
                textInputType: TextInputType.number,
                onSaved: (value) => _unitAmount = num.parse(value!),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Product Code',
                textInputType: TextInputType.number,
                onSaved: (value) => _code = value!.toLowerCase(),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Product Description',
                textInputType: TextInputType.text,
                maxLines: 5,
                onSaved: (value) => _description = value?.trim(),
              ),
              const SizedBox(height: 16),
              ProductOptionToggle(
                label: 'Is Product Organic?',
                value: _isOrganic,
                onChanged: (value) => setState(() => _isOrganic = value),
              ),
              const SizedBox(height: 16),
              ProductOptionToggle(
                label: 'Is Featured Item?',
                value: _isFeatured,
                onChanged: (value) => setState(() => _isFeatured = value),
              ),
              const SizedBox(height: 16),
              ProductImagePickerField(
                onFileChanged: (image) => _selectedImage = image,
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _submitForm,
                text: 'Add Product',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final image = _selectedImage;
    if (image == null) {
      _showImageError();
      return;
    }

    final formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    if (!formState.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }

    formState.save();

    final formData = AddProductFormData(
      name: _name!,
      code: _code!,
      description: _description!,
      price: _price!,
      expirationMonths: _expirationMonths!,
      numberOfCalories: _numberOfCalories!,
      unitAmount: _unitAmount!,
      image: image,
      isFeatured: _isFeatured,
      isOrganic: _isOrganic,
    );

    context.read<AddProductCubit>().addProduct(formData.toEntity());
  }

  void _showImageError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select an image'),
      ),
    );
  }
}
