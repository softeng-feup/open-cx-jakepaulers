import 'package:cloud_firestore/cloud_firestore.dart';

class Conference {
  String name;
  String room;
  String title;
  DocumentReference reference;

  Conference(this.name, this.room, this.title);

  Conference.fromSnapshot(DocumentSnapshot snapshot):
        name = snapshot.data['name'],
        room = snapshot.data['room'],
        title = snapshot.data['title'],
        reference = snapshot.reference;

  Map<String, dynamic> toMap() => {'name' : name, 'room': room, 'title' : title};

  static void addToCollection(Conference conference) {
    getCollection().add(conference.toMap());
  }

  static CollectionReference getCollection() => Firestore.instance.collection('conferences');
}
