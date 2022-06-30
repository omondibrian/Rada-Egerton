import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/presentation/widgets/button.dart';
import 'package:rada_egerton/resources/utils/main.dart';

import 'package:flutter/material.dart';

class NewGroupForm extends StatelessWidget {
  final grpNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NewGroupForm({Key? key}) : super(key: key);

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    File? imageFile;
    void _updateProfileImage() async {
      imageFile = await ServiceUtility().uploadImage();
    }

    void _handleSubmit(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        context
            .read<RadaApplicationProvider>()
            .createNewGroup(
              grpNameController.text,
              descriptionController.text,
              imageFile,
            )
            .then(
          (info) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  info.message,
                  style: TextStyle(color: info.messageTypeColor),
                ),
              ),
            );
            Navigator.of(context).pop();
          },
        );
      }
    }

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200))),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Create New Group",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Positioned(
                  left: 100,
                  top: 30,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.black),
                      onPressed: _updateProfileImage,
                    ),
                  ),
                ),
                SizedBox(
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: "GroupName",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide:
                            BorderSide(color: Color(0X55CED0D2), width: 0.0),
                      ),
                    ),
                    controller: grpNameController,
                    validator: validator,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textAlign: TextAlign.start,
                  maxLines: 10,
                  minLines: 4,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    hintText: "Description ...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide:
                          BorderSide(color: Color(0X55CED0D2), width: 0.0),
                    ),
                  ),
                  controller: descriptionController,
                  validator: validator,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
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
                        handleClick: () => Navigator.of(context).pop(),
                        fill: false,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
