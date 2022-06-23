import 'package:flutter/material.dart';

class DefaultInput extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final IconData icon;
  final void Function(String value)? onChange;
  const DefaultInput(
      {Key? key,
      this.onChange,
      required this.hintText,
      this.controller,
      required this.validator,
      required this.icon,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        obscureText: isPassword,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Color(0X55CED0D2), width: 0.0),
          ),
        ),
        controller: controller,
        validator: validator,
        onChanged: onChange,
      ),
    );
  }
}
