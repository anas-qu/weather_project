abstract class SetUserInfoStates {}

class InitialUsersinfo extends SetUserInfoStates {}

class UserRegister extends SetUserInfoStates {}

class UserRegisterSuccess extends SetUserInfoStates {}

class PickImage extends SetUserInfoStates {}

class UserRegisterFailed extends SetUserInfoStates {
  String error;

  UserRegisterFailed(this.error);
}

