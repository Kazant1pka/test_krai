import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.icon,
    required this.initialValue,
    required this.labelText,
    required this.isEnabled,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.formatter,
    this.errorText,
    this.maxLines = 1,
    super.key,
  });

  final IconData icon;
  final String initialValue;
  final String labelText;
  final String hintText;
  final String? errorText;
  final bool isEnabled;
  final List<TextInputFormatter>? formatter;
  final TextInputType? keyboardType;
  final VoidCallback? Function(String title) onChanged;
  final String? Function(String? title)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: labelText,
        prefixIcon: Icon(icon),
        hintText: hintText,
        errorText: errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
      maxLines: maxLines,
      inputFormatters: formatter,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
