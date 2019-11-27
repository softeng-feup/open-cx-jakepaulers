import 'package:askkit/Model/Talk.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Pages/LogInPage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/CenterText.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:askkit/View/Widgets/CustomListView.dart';
import 'package:askkit/View/Widgets/TalkCard.dart';
import 'package:flutter/material.dart';

class TalksPage extends StatefulWidget {
  final DatabaseController _dbcontroller;

  TalksPage(this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return TalksPageState();
  }

}

class TalksPageState extends State<TalksPage> implements ModelListener {
  List<Talk> talks = new List();

  bool loaded = false;
  ScrollController scrollController;

  @override void initState() {
    scrollController = ScrollController();
    this.refreshModel();
  }

  @override void dispose() {
    super.dispose();
  }

  Future<void> refreshModel() async {
    Stopwatch sw = Stopwatch()..start();
    talks = await widget._dbcontroller.getTalks();
    if (this.mounted)
      setState(() { loaded = true; });
    print("Talks fetch time: " + sw.elapsed.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.subdirectory_arrow_left), onPressed: signOut),
          title: Text("‹Programming› 2020"),
          backgroundColor: Theme.of(context).primaryColor
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: getBody()
    );
  }

  Widget getBody() {
    if (!this.loaded)
      return LinearProgressIndicator();
    return talkList();
  }


  Widget talkList() {
    if (talks.length == 0 && this.loaded)
      return CenterText("No talks found.\nWhat if someone started one? 🤔", textScale: 1.25);
    return CustomListView(
        onRefresh: refreshModel,
        controller: scrollController,
        itemCount: this.talks.length,
        itemBuilder: (BuildContext context, int i) {
          return Column(
            children: <Widget>[
              TalkCard(this, this.talks[i], widget._dbcontroller),
              Divider(height: 1, thickness: 1,),
            ],
          );
        }
    );
  }

  void signOut() {
    ConfirmDialog(
        title: "Signing out...",
        content: "Are you sure you want to sign out?",
        context: context,
        yesPressed: () async {
          await widget._dbcontroller.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage(widget._dbcontroller)));
        },
        noPressed: () {}
    ).show();
  }
}