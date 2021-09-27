abstract class GetUserInfoState{}

class InitialGetUserInfo extends GetUserInfoState {}

class GetUserInfoSuccess extends GetUserInfoState {}

class UserRegister extends GetUserInfoState {}

class UserRegisterSuccess extends GetUserInfoState {}

class PickImage extends GetUserInfoState {}

class UserRegisterFailed extends GetUserInfoState {
  String error;

  UserRegisterFailed(this.error);
}