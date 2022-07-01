import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/profile/bloc/bloc.dart';
import 'package:rada_egerton/presentation/widgets/button.dart';
import 'package:rada_egerton/resources/config.dart';

class ProfileDetails extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode userName = FocusNode();

  ProfileDetails({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              current.readOnly != previous.readOnly,
          listener: (context, state) {
            if (!state.readOnly && userName.canRequestFocus) {
              userName.requestFocus();
            }
          },
          buildWhen: (previous, current) {
            if (current.user != previous.user) return true;
            if (current.readOnly != previous.readOnly) return true;
            if (current.status != previous.status) return true;
            return false;
          },
          builder: (context, state) {
            if (state.status == ServiceStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.status == ServiceStatus.loadingFailure) {
              return Row(
                children: [
                  const Text("An error occured"),
                  TextButton(
                    onPressed: () => context.read<ProfileCubit>().getUser(),
                    child: const Text("RETRY"),
                  )
                ],
              );
            }
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Enter userName",
                    ),
                    onChanged: (value) =>
                        context.read<ProfileCubit>().nameChanged(value),
                    enabled: !state.readOnly,
                    autofocus: true,
                    focusNode: userName,
                    validator: RequiredValidator(errorText: "Required"),
                    initialValue: state.nameUpdate,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Enter phone number",
                    ),
                    onChanged: (value) =>
                        context.read<ProfileCubit>().phoneChanged(value),
                    enabled: !state.readOnly,
                    initialValue: state.phoneUpdate,
                    validator: RequiredValidator(errorText: "Required"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_box_outlined),
                    title: const Text("Account status"),
                    subtitle: Text("${state.user!.accountStatus}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text("Email"),
                    subtitle: Text(state.user!.email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text("Date of Birth"),
                    subtitle: Text("${state.user!.dob}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Gender"),
                    subtitle: Text(
                      "${state.user!.gender}",
                    ),
                  ),
                  if (!state.readOnly &&
                      state.user?.id == GlobalConfig.instance.user.id)
                    Row(
                      children: [
                        Expanded(
                          child: _SubmitButton(_formKey),
                        ),
                        Expanded(
                          child: RadaButton(
                            fill: false,
                            handleClick: () =>
                                context.read<ProfileCubit>().readOnlyToggle(),
                            title: "Cancel",
                          ),
                        )
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const _SubmitButton(this.formKey);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) {
        if (previous.status != current.status) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state.status == ServiceStatus.submiting) {
          return const RadaButtonProgress(
            title: "Save",
          );
        }
        return RadaButton(
          fill: true,
          handleClick: () {
            if (formKey.currentState?.validate() == true) {
              context.read<ProfileCubit>().updateProfile();
            }
          },
          title: "Save",
        );
      },
    );
  }
}
