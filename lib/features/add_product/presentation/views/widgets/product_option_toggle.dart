import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_styles.dart';
import 'custom_check_box.dart';

class ProductOptionToggle extends StatelessWidget {
  const ProductOptionToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.semiBold13.copyWith(
              color: const Color(0xFF949D9E),
            ),
          ),
        ),
        const SizedBox(width: 16),
        CustomCheckBox(
          isChecked: value,
          onChecked: onChanged,
        ),
      ],
    );
  }
}
