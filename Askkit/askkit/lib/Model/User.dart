import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
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
}
