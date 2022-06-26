import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/services/auth_service.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part "state.dart";

class ProfileCubit extends Cubit<ProfileState> {
  ///userId is provided to view a profile of a given user
  final int? userId;
  final RadaApplicationProvider provider;
  ProfileCubit({
    this.userId,
    required this.provider,
  }) : super(const ProfileState()) {
    if (userId == null) {
      final user = GlobalConfig.instance.user;
      emit(
        state.copyWith(
          user: user,
          status: ServiceStatus.loadingSuccess,
          emailUpdate: user.email,
          phoneUpdate: user.phone,
          nameUpdate: user.name,
        ),
      );
    } else {
      getUser();
    }
  }
  getUser() async {
    // start loading user profile
    emit(
      state.copyWith(
        status: ServiceStatus.loading,
      ),
    );
    final res = await provider.getUser(
      userId: userId ?? GlobalConfig.instance.user.id,
    );
    res.fold(
      (user) => emit(
        state.copyWith(
          user: user,
          status: ServiceStatus.loadingSuccess,
          emailUpdate: user.email,
          phoneUpdate: user.phone,
          nameUpdate: user.name,
        ),
      ),
      (info) => emit(
        state.copyWith(
          status: ServiceStatus.loadingFailure,
          message: info,
        ),
      ),
    );
  }

  readOnlyToggle() {
    emit(
      state.copyWith(readOnly: !state.readOnly),
    );
  }

  emailChanged(String value) {
    emit(
      state.copyWith(emailUpdate: value),
    );
  }

  nameChanged(String value) {
    emit(
      state.copyWith(nameUpdate: value),
    );
  }

  phoneChanged(String value) {
    emit(
      state.copyWith(phoneUpdate: value),
    );
  }

  updateProfile() async {
    if (state.user == null) return;
    //start profile update
    emit(
      state.copyWith(
        status: ServiceStatus.submiting,
        message: InfoMessage(
          "Updating profile please wait",
          MessageType.success,
        ),
      ),
    );
    final res = await AuthService.updateProfile(
      state.user!.copyWith(
        email: state.emailUpdate,
        phone: state.phoneUpdate,
        name: state.nameUpdate,
      ),
    );
    res.fold(
      (user) {
        emit(
          state.copyWith(
            status: ServiceStatus.submissionSucess,
            user: user,
            message: InfoMessage("Profile Updated", MessageType.success),
          ),
        );
        GlobalConfig.instance.inialize(user: user);
      },
      (error) => emit(
        state.copyWith(
          status: ServiceStatus.submissionFailure,
          message: InfoMessage.fromError(error),
        ),
      ),
    );
  }

  updateProfileImage() async {
    File? imageFile = await ServiceUtility().uploadImage();
    if (imageFile == null) return;
    emit(
      state.copyWith(
        message: InfoMessage("Updating profile image..", MessageType.success),
      ),
    );
    String imageFileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap(
      {
        "profilePic": await MultipartFile.fromFile(imageFile.path,
            filename: imageFileName),
      },
    );
    final res = await AuthService.updateProfileImage(formData);
    res.fold(
      (user) {
        emit(
          state.copyWith(
            user: user,
            message: InfoMessage(
              "Profile updated",
              MessageType.success,
            ),
          ),
        );
        GlobalConfig.instance.inialize(user: user);
      },
      (error) => emit(
        state.copyWith(
          message: InfoMessage.fromError(error),
        ),
      ),
    );
  }
}
