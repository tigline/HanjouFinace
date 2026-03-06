import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final formatted = _formatWithCommas(digits);
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// 格式化货币字符串，添加逗号分隔
  static String formatCurrency(String value) {
    if (value.isEmpty) return value;

    final digits = value.replaceAll(',', '');
    if (digits.isEmpty) return '';

    return _formatWithCommas(digits);
  }

  static String _formatWithCommas(String digits) {
    return digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}