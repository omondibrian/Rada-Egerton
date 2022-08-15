import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/rest/client.dart';
import 'package:rada_egerton/presentation/widgets/button.dart';
import 'package:rada_egerton/presentation/widgets/input.dart';
import 'package:rada_egerton/resources/size_config.dart';

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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 10),
                            content: Text(
                              "Searching, please wait...",
                              style: TextStyle(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                        );
                        var result = await Client.users.queryUser(
                          queryStringController.text,
                          retryLog: (message) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                message,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        );
                        result.fold(
                          (user) => setState(
                            () {
                              this.user = user;
                            },
                          ),
                          (err) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                err.message,
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            ),
                          ),
                        );
                      },
                      fill: false,
                    ),
                  ),
                ],
              ),
              if (user != null)
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0,
                  ),
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user!.profilePic,
                        imageBuilder: (context, imageProvider) => Container(
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
                  subtitle: Text(
                    user!.email,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: TextButton(
                    child: const Text('Add'),
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 10),
                          content: Text(
                            "Adding user, please wait...",
                            style: TextStyle(
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      );
                      var result = await Client.counselling.subGroup(
                        user!.id.toString(),
                        widget.groupId,
                      );

                      result.fold(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                "User ${user!.email}, has been added to the group",
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                          );
                          context.pop();
                        },
                        (err) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              err.message,
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
