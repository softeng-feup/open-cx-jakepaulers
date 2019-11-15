import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Talk {
  String title;
  String room;
  String description;
  User host;
  DocumentReference reference;

  Talk(this.title, this.host, this.room, this.description, this.reference);
}
