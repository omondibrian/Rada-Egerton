import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/providers/chat.provider.dart';
import 'package:rada_egerton/resources/utils/main.dart';

import 'RadaButton.dart';
import 'package:flutter/material.dart';

Widget newGroupForm(
  BuildContext context,
  RadaApplicationProvider radaApplicationProvider,
) {
  File? imageFile;
  final grpNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _chatProvide = Provider.of<ChatProvider>(context);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final _info = await radaApplicationProvider.createNewGroup(
        grpNameController.text,
        descriptionController.text,
        imageFile,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _info.message,
            style: TextStyle(color: _info.messageTypeColor),
          ),
        ),
      );
      context.pop();
    }
  }

  validator(value) {
    if (value == null || value.isEmpty) {
      return 'This value is required';
    }
  }

  void _updateProfileImage() async {
    imageFile = await ServiceUtility().uploadImage();
  }

  return Wrap(children: [
    Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Form(
        key: _formKey,
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
                  icon: Icon(Icons.camera_alt, color: Colors.black),
                  onPressed: _updateProfileImage,
                ),
              ),
            ),
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
                  handleClick: () => context.pop(),
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
