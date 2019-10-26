import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

StreamBuilder<QuerySnapshot> makeStreamBuilder(Query query, Widget Function(DocumentSnapshot document) item_builder) {
  return StreamBuilder<QuerySnapshot>(
    stream: query.snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      List<DocumentSnapshot> documents = snapshot.data.documents;
      return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, i) {
            return item_builder(documents[i]);
          }
      );
    },
  );
}
