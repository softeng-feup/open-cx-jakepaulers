import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  String username;
  String name;
  NetworkImage image;
  DocumentReference reference;

  User(this.username, this.name, this.image);

  User.fromSnapshot(DocumentSnapshot snapshot):
        username = snapshot.data['username'],
        name = snapshot.data['name'],
        image = new NetworkImage(snapshot.data['image']),
        reference = snapshot.reference;

  Map<String, dynamic> toMap() => {'username' : username, 'name': name, 'image' : image.url};

  static void addToCollection(User user) {
    getCollection().add(user.toMap());
  }

  static CollectionReference getCollection() => Firestore.instance.collection('users');
}
