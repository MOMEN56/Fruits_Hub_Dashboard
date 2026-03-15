import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_styles.dart';
import 'custom_check_box.dart';

class IsOrganciCheckBox extends StatefulWidget {
  const IsOrganciCheckBox({super.key, required this.onChanged});

  final ValueChanged<bool> onChanged;
  @override
  State<IsOrganciCheckBox> createState() => _IsOrganciCheckBoxState();
}

class _IsOrganciCheckBoxState extends State<IsOrganciCheckBox> {
  bool isOrganic = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'is Product Organic?',
                  style: TextStyles.semiBold13.copyWith(
                    color: const Color(0xFF949D9E),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        CustomCheckBox(
          onChecked: (value) {
            isOrganic = value;
            widget.onChanged(value);
            setState(() {});
          },
          isChecked: isOrganic,
        ),
      ],
    );
  }
}
