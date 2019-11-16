import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Talk {
  String title;
  String room;
  String description;
  User host;
  DateTime startDate;
  DocumentReference reference;

  Talk(this.title, this.description, this.startDate, this.host, this.room, this.reference);

  String getStartDate() {
    String date =  DateFormat('dd/MM').format(startDate.toLocal());
    String time =  DateFormat('HH:mm').format(startDate.toLocal());
    return date + " at " + time;
  }
}
