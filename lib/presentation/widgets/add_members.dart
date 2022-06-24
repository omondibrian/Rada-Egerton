import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/entities/UserDTO.dart';
import 'package:rada_egerton/presentation/widgets/RadaButton.dart';
import 'package:rada_egerton/presentation/widgets/defaultInput.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/data/services/counseling_service.dart';
import 'package:rada_egerton/resources/sizeConfig.dart';

class AddMembers extends StatefulWidget {
  final String groupId;
  const AddMembers({required this.groupId, Key? key}) : super(key: key);

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  User? user;
  @override
  Widget build(BuildContext context) {
    final queryStringController = TextEditingController();
    validator(value) {
      if (value == null || value.isEmpty) {
        return 'This value is required';
      }
    }

    final style = TextStyle(
      fontSize: SizeConfig.isTabletWidth ? 16 : 14,
    );
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DefaultInput(
                      hintText: "enter email for new member",
                      controller: queryStringController,
                      validator: validator,
                      icon: Icons.email_outlined,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RadaButton(
                      title: 'search',
                      handleClick: () async {
                        var result = await CounselingService.queryUserData(
                            queryStringController.text);
                        result.fold(
                          (user) => setState(() {
                            this.user = user;
                          }),
                          (err) => print(err.message),
                        );
                      },
                      fill: false,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (user != null)
                    GestureDetector(
                      onTap: () async {
                        var result = await CounselingService.subToNewGroup(
                          user!.id.toString(),
                          widget.groupId,
                        );

                        result!.fold(
                          (_) => context.pop(),
                          (err) => print(err),
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: imageUrl(user!.profilePic),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: Text(user!.name, style: style),
                          subtitle: Row(
                            children: [
                              Text(
                                "email:",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: SizeConfig.isTabletWidth ? 16 : 14,
                                ),
                              ),
                              Text(user!.email, style: style),
                            ],
                          ),
                          trailing: const Text('Add'),
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
