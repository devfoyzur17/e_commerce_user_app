import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_user_app/auth/auth_service.dart';
import 'package:e_commerce_user_app/models/address_model.dart';
import 'package:e_commerce_user_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserModel {
  String uid;
  String? name;
  String email;
  String? mobile;
  String? image;
  AddressModel? address;
  Timestamp userCreationTime;
  String? deviceToken;

  UserModel({
    required this.uid,
    this.name,
    required this.email,
    this.mobile,
    this.image,
    this.address,
    required this.userCreationTime,
    this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uid": uid,
      "name": name,
      "mobile": mobile,
      "email": email,
      "image": image,
      "address": address,
      "deviceToken": deviceToken,
      "userCreationTime": userCreationTime
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map["uid"],
        name: map["name"],
        mobile: map["mobile"],
        email: map["email"],
        image: map["image"],
        address: map["address"]==null ? map["address"] : AddressModel.fromMap(map["address"]) ,
        deviceToken: map["deviceToken"],
        userCreationTime: map['userCreationTime'],
      );
}
