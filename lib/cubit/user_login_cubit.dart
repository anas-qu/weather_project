import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_login_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserLoginCubit extends Cubit<UserLogin>
{
  UserLoginCubit() : super(InitialUserLogin());
  static UserLoginCubit get(context) => BlocProvider.of(context);
  User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;

  bool hidePass = true;


  void signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
      Fluttertoast.showToast(msg: "Login Successful"),
      emit(UserLoginSuccess()),
    })
        .catchError((e) {
      emit(UserLoginFailed(e));
      Fluttertoast.showToast(msg: e!.message);
    });
  }

}





