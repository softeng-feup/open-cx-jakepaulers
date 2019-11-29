import 'package:askkit/Icons/custom_icons.dart';
import 'package:askkit/Model/Talk.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Controllers/TalkSearchDelegate.dart';
import 'package:askkit/View/Pages/LogInPage.dart';
import 'package:askkit/View/Pages/ProfilePage.dart';
import 'package:askkit/View/Widgets/CenterText.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:askkit/View/Widgets/CustomListView.dart';
import 'package:askkit/View/Widgets/ShadowDecoration.dart';
import 'package:askkit/View/Widgets/TalkCard.dart';
import 'package:askkit/View/Widgets/UserAvatar.dart';
import 'package:flutter/material.dart';


class TalksPage extends StatefulWidget {
  final DatabaseController _dbcontroller;
  final SearchDelegate talkSearchDelegate;

  TalksPage(this._dbcontroller) : talkSearchDelegate = TalkSearchDelegate(_dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return TalksPageState();
  }

}

class TalksPageState extends State<TalksPage> implements ModelListener {
  List<Talk> talks = new List();

  bool dayTheme = true;
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
          title: Text("‹Programming› 2020"),
          backgroundColor: Theme.of(context).primaryColor
        ),
        drawer: getDrawer(context),
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

  Widget getDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: drawerOptions()),
          Divider(height: 1, thickness: 1, color: Theme.of(context).iconTheme.color),
          this.dayTheme ? toNightButton() : toDayButton()
        ],
      )
    );
  }

  Widget toNightButton() {
    return FlatButton(
      color: Colors.lightBlueAccent,
      shape: ContinuousRectangleBorder(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.wb_sunny, color: Colors.yellow)
      ),
      onPressed: switchMode,
    );
  }

  Widget toDayButton() {
    return FlatButton(
      color: Color(0xFF1A008E),
      shape: ContinuousRectangleBorder(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Icon(CustomIcons.moon, color: Colors.white)
      ),
      onPressed: switchMode,
    );
  }

  Widget drawerOptions() {
    return ListView(
        children: <Widget>[
          DrawerHeader(
              padding: EdgeInsets.only(left: 16),
              child: UserAvatar(widget._dbcontroller.getCurrentUser(),
                  avatarRadius: 35.0,
                  textStyle: Theme.of(context).textTheme.body2.copyWith(fontSize: 22)
              ),
              decoration: ShadowDecoration(color:Theme.of(context).primaryColorLight,  blurRadius: 2.0, spreadRadius: 0.0, offset:  Offset(0, 1))
          ),
          ListTile(
            leading: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
            title: Text('My Profile'),
            onTap: toMyProfile,
          ),
          ListTile(
            leading: Icon(Icons.clear, color: Theme.of(context).iconTheme.color),
            title: Text('Sign out'),
            onTap: signOut,
          ),
          Divider(height: 1, thickness: 1),
          ListTile(
            leading: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
            title: Text('Search'),
            onTap: search,
          ),
        ]
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

  void toMyProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(widget._dbcontroller.getCurrentUser(), widget._dbcontroller)));
  }

  void search() async {
    await showSearch<Talk>(
      context: context,
      delegate: widget.talkSearchDelegate
    );
  }

  void switchMode() {
    setState(() {
      this.dayTheme = !this.dayTheme;
    });

  }
}