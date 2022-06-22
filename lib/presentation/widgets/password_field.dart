import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//password field
class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField(this.controller);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          obscureText: hidePassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  const BorderSide(color: Color(0X55CED0D2), width: 0.0),
            ),
            prefixIcon: Icon(Icons.lock),
            hintText: "Password",
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            suffix: InkWell(
                onTap: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                child: Icon(
                  hidePassword ? Icons.visibility : Icons.visibility_off,
                )),
          ),
          controller: widget.controller,
          validator: passwordValidator,
        ));
  }
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This value is required';
  }
  // else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
  //   return 'Incorrect password';
  // }
  return null;
}
