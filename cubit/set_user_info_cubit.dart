import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'set_user_info.dart';
import 'package:weather_project/model/user_model..dart';
import 'package:fluttertoast/fluttertoast.dart';

class UsersInfoCubit extends Cubit<SetUserInfoStates>
{
  UsersInfoCubit() : super(InitialUsersinfo());

  static UsersInfoCubit get(context) => BlocProvider.of(context);

/*Picked Image*/
  File? imageFile;
  String? imageUrl;
  final _auth = FirebaseAuth.instance;

  getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null)
      imageFile = File(pickedFile.path);

    emit(PickImage());
  }
  getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null)
      imageFile = File(pickedFile.path);

    emit(PickImage());
  }
  void signUp(String email, String password,String firstName,String secondName,String phone )
  async {
    await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(firstName, secondName, phone)})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        emit(UserRegisterFailed(e));
      });

  }

  postDetailsToFirestore(String firstName,String secondName,String phone,) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    final ref =
    FirebaseStorage.instance.ref().child('userImage').child(user!.uid + '.jpg');
    await ref.putFile(imageFile!);


    UserModel userModel = UserModel();

    //writing all the values
    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.firstName = firstName;
    userModel.secondName = secondName;
    userModel.phone = phone;

    userModel.imageUrl=imageUrl;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
    emit(UserRegisterSuccess());

  }
}