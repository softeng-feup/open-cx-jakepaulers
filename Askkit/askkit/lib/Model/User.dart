import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  String username;
  String name;
  NetworkImage image;
  DocumentReference reference;

  User(this.username, this.name, this.image);

  //User.forTest(this.username) {
  //  this.name = this.username;
   // this.image = NetworkImage('https://noticias.up.pt//wp-content/uploads/2019/05/Pedro-Mo%C3%A1s-interior-e1556272376936.jpg');
  //}

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

  static Future<User> fetchUser(String username) async {
    QuerySnapshot snapshot = await getCollection().where("username", isEqualTo: username).limit(1).getDocuments();
    if (snapshot.documents.length == 0) {
      User newUser = User(username, username, NetworkImage("http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"));
      addToCollection(newUser);
      return newUser;
    }
    return User.fromSnapshot(snapshot.documents[0]);
  }
}
