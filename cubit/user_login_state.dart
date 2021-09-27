abstract class UserLogin {}

class InitialUserLogin extends UserLogin {}

class UserLoginSuccess extends UserLogin {}

class UserLoginFailed extends UserLogin {
  String error;

  UserLoginFailed(this.error);
}