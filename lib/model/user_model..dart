
class UserModel {
  String? uid;
  String? firstName;
  String? secondName;
  String? phone;
  String? email;
  int? password;


  UserModel({this.uid,this.firstName, this.secondName,this.phone,this.email,this.password});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      phone: map['phone'],
      email: map['email'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'secondName': secondName,
      'phone':phone,
      'email': email,
    };
  }
}