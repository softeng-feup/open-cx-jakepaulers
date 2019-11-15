import 'package:askkit/Model/Talk.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Pages/LogInPage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
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

class TalksPageState extends State<TalksPage> {
  List<Talk> talks = new List();

  bool loading = false;
  ScrollController scrollController;

  @override void initState() {
    scrollController = ScrollController();
    this.fetchTalks();
  }

  @override void dispose() {
    super.dispose();
  }

  void fetchTalks() async {
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
            IconButton(icon: Icon(Icons.refresh), onPressed: fetchTalks),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: getBody()
    );
  }

  Widget getBody() {
    return Column(
        children: <Widget>[
          Visibility( visible: this.loading, child: CardTemplate.loadingIndicator(context)),
          Expanded(child: talkList())
        ]
    );
  }


  Widget talkList() {
    if (talks.length == 0 && !this.loading)
      return Center(child: Text("No talks found.\nWhat if someone started one? 🤔", textScaleFactor: 1.25, textAlign: TextAlign.center));
    return ListView.builder(
        controller: scrollController,
        itemCount: this.talks.length,
        itemBuilder: (BuildContext context, int i) {
          return TalkCard(this.talks[i], widget._dbcontroller);
        }
    );
  }

  void signOut() {
    widget._dbcontroller.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage(widget._dbcontroller)));
  }
}
