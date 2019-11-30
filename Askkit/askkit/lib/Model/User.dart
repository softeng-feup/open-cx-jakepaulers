import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  static final String defaultAvatar = "https://firebasestorage.googleapis.com/v0/b/askkit-3071b.appspot.com/o/userImages%2FdefaultAv.jpg?alt=media&token=4c6e8616-b5d4-47eb-9c4b-259b95843dc0";
  static final String nullAvatar = "https://firebasestorage.googleapis.com/v0/b/askkit-3071b.appspot.com/o/userImages%2FnullAvatar.png?alt=media&token=06da53fa-f476-4835-8682-a4c973aa3239";

  String username;
  String email;
  String name;
  String image;
  String bios;
  DocumentReference reference;

  NetworkImage networkImage;

  User.empty() {
    this.image = nullAvatar;
    this.username = "--User_Not_Found--";
  }
  User(this.username, this.email, this.name, this.image, this.bios, this.reference);

  NetworkImage getImage() {
    if (networkImage == null || networkImage.url != this.image)
        networkImage = NetworkImage(this.image);
    return this.networkImage;
  }

  bool operator==(covariant User other) => other.username == this.username;
}