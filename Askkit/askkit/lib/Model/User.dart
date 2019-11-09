import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  static final String defaultAvatar = "https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";

  String username;
  String email;
  String name;
  String image;
  DocumentReference reference;

  NetworkImage networkImage;

  User(this.username, this.email, this.name, this.image, this.reference);

  NetworkImage getImage() {
    if (networkImage == null || networkImage.url != this.image)
        networkImage = NetworkImage(this.image);
    return this.networkImage;
  }

  bool isNull() {
    return false;
  }
}

class NullUser extends User {
  static final String nullAvatar = "https://cdn0.iconfinder.com/data/icons/handdrawn-ui-elements/512/Question_Mark-512.png";

  NullUser() : super("--User_Not_Found--", "null", "null", NullUser.nullAvatar, null);

  bool isNull() {
    return true;
  }

}