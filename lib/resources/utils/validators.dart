  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    } else if (!RegExp(
            r'^.+@[a-zA-Z0-9]+\.{1}[a-zA-Z0-9]+(\.{0,1}[a-zA-Z0-9]+)+$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }