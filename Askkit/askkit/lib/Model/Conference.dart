import 'package:cloud_firestore/cloud_firestore.dart';

class Conference {
  String name;
  String room;
  String title;
  DocumentReference reference;

  Conference(this.name, this.room, this.title, this.reference);
}
