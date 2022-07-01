import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/presentation/widgets/button.dart';
import 'package:rada_egerton/resources/utils/main.dart';

import 'package:flutter/material.dart';

class NewGroupForm extends StatefulWidget {
  const NewGroupForm({Key? key}) : super(key: key);

  @override
  State<NewGroupForm> createState() => _NewGroupFormState();
}

class _NewGroupFormState extends State<NewGroupForm> {
  final grpNameController = TextEditingController();
  final descriptionController = TextEditingController();
  File? imageFile;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    void _updateProfileImage() async {
      imageFile = await ServiceUtility().uploadImage();
      setState(() {});
    }

    void _handleSubmit(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 10),
            content: Text(
              "Creating group, please wait...",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        );
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
            if (info.messageType == MessageType.success) {
              Navigator.of(context).pop();
            }
          },
        );
      }
    }

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
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
                Stack(
                  children: [
                    CircleAvatar(
                      maxRadius: 80,
                      backgroundImage: imageFile == null
                          ? Image.asset("assets/users.png").image
                          : Image.file(imageFile!).image,
                    ),
                    Positioned(
                      right: 20,
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: _updateProfileImage,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
