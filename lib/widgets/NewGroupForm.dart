import 'RadaButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';

Widget NewGroupForm(
  BuildContext context,
  RadaApplicationProvider radaApplicationProvider,
) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final grpNameController = TextEditingController();
  final descriptionController = TextEditingController();

  void _handleSubmit(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        radaApplicationProvider.createNewGroup(
            grpNameController.text, descriptionController.text);
      }
    } catch (e) {
      print(e);
    }
  }

  validator(value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    }
  }

  return Wrap(children: [
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              child: TextFormField(
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  hintText: "GroupName",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide:
                        const BorderSide(color: Color(0X55CED0D2), width: 0.0),
                  ),
                ),
                controller: grpNameController,
                validator: validator,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              textAlign: TextAlign.start,
              maxLines: 10,
              minLines: 4,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                hintText: "Description ...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide:
                      const BorderSide(color: Color(0X55CED0D2), width: 0.0),
                ),
              ),
              controller: descriptionController,
              validator: validator,
            ),
            SizedBox(
              height: 30,
            ),
            Row(children: [
              Expanded(
                child: RadaButton(
                  title: 'create',
                  handleClick: () => _handleSubmit(context),
                  fill: true,
                ),
              ),
              Expanded(
                child: RadaButton(
                  title: 'close',
                  handleClick: () => _handleSubmit(context),
                  fill: false,
                ),
              ),
            ])
          ],
        ),
      ),
    ),
  ]);
}
