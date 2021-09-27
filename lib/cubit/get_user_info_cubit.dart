import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weather_project/model/user_model..dart';
import 'get_user_info.dart';

class GetUserInfo extends Cubit<GetUserInfoState> {
  GetUserInfo() : super(InitialGetUserInfo());

  static GetUserInfo get(context) => BlocProvider.of(context);

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  void getLoggedInUserInfo() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      emit(GetUserInfoSuccess());
    });
  }

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

  updateDetailsToFirestore(String firstName,String secondName,String phone,String email,String password) async {
    // calling our firestore
    // calling our user model
    // uploading these values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstName;
    userModel.secondName = secondName;
    userModel.phone = phone;

    final ref = FirebaseStorage.instance.ref().child('userImage').child(
        user.uid + '.jpg');
    await ref.putFile(imageFile!);
    userModel.imageUrl = await ref.getDownloadURL();

    user.updatePassword(password);
    user.updateEmail(email);

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Data has been Updated ");

  }



}