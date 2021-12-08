import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rada_egerton/providers/ApplicationProvider.dart';
import 'package:rada_egerton/theme.dart';
import 'package:rada_egerton/widgets/RadaButton.dart';
import 'package:rada_egerton/widgets/defaultInput.dart';

import '../sizeConfig.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String? groupId;
  CustomAppBar({
    Key? key,
    required this.title,
    required this.imgUrl,
    this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radaApplicationProvider = Provider.of<RadaApplicationProvider>(context);
    void _openBottomSheet() {
      showBottomSheet(
          context: context,
          builder: (context) {
            final theme = Theme.of(context);
            return Wrap(
              children: [
                ListTile(
                  title: Text('Title 1'),
                ),
                ListTile(
                  title: Text('Title 2'),
                ),
                ListTile(
                  title: Text('Title 3'),
                ),
                ListTile(
                  title: Text('Title 4'),
                ),
                ListTile(
                  title: Text('Title 5'),
                ),
              ],
            );
          });
    }

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

    void _addNewGroup() {
      showBottomSheet(
          context: context,
          builder: (context) {
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            hintText: "GroupName",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: const BorderSide(
                                  color: Color(0X55CED0D2), width: 0.0),
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
                            borderSide: const BorderSide(
                                color: Color(0X55CED0D2), width: 0.0),
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
          });
    }

    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        CircleAvatar(
          backgroundImage: NetworkImage(this.imgUrl),
          backgroundColor: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(this.title, style: Theme.of(context).textTheme.headline3),
                Text(
                  'say Something',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Palette.accent, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text('Add Member'),
              onTap: _openBottomSheet,
            ),
            PopupMenuItem(
              child: Text('New Group'),
              onTap: _addNewGroup,
            ),
            PopupMenuItem(
                child: Text(
                  'Leave Group',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => radaApplicationProvider.leftGroup(this.groupId!)),
          ],
        )
      ],
    );
  }
}
