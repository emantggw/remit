class ValidatorUtils {
  static String? emailValidator(String? v) {
    if (v == null || v.isEmpty) {
      return 'Please enter email';
    }
    final pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(pattern).hasMatch(v)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? nameValidator(String? v) {
    if (v == null || v.isEmpty) {
      return 'Please enter name';
    }
    return null;
  }

  static String? passwordValidator(String? v) {
    if (v == null || v.isEmpty) {
      return 'Please enter password';
    }
    if (v.length < 6) return 'Too short password';
    return null;
  }
}
