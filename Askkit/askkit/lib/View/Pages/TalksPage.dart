import 'package:askkit/Model/Talk.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Pages/LogInPage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/CenterText.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
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

  bool loading = false;
  ScrollController scrollController;

  @override void initState() {
    scrollController = ScrollController();
    this.refreshModel();
  }

  @override void dispose() {
    super.dispose();
  }

  void refreshModel() async {
    Stopwatch sw = Stopwatch()..start();
    setState(() { loading = true; });
    talks = await widget._dbcontroller.getTalks();
    if (this.mounted)
      setState(() { loading = false; });
    print("Talks fetch time: " + sw.elapsed.toString());

    if (scrollController.hasClients)
      scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.subdirectory_arrow_left), onPressed: signOut),
          title: Text("‹Programming› 2020"),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: refreshModel),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: getBody()
    );
  }

  Widget getBody() {
    return Column(
        children: <Widget>[
          Visibility( visible: this.loading, child: LinearProgressIndicator()),
          Expanded(child: talkList())
        ]
    );
  }


  Widget talkList() {
    if (talks.length == 0 && !this.loading)
      return CenterText("No talks found.\nWhat if someone started one? 🤔", textScale: 1.25);
    return ListView.builder(
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
