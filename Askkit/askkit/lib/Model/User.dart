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

  User.empty() {
    this.image = "https://cdn0.iconfinder.com/data/icons/handdrawn-ui-elements/512/Question_Mark-512.png";
    this.username = "--User_Not_Found--";
  }
  User(this.username, this.email, this.name, this.image, this.reference);

  NetworkImage getImage() {
    if (networkImage == null || networkImage.url != this.image)
        networkImage = NetworkImage(this.image);
    return this.networkImage;
  }

  bool operator==(covariant User other) => other.username == this.username;
}