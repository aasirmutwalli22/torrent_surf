import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/let.dart';
import 'package:url_launcher/url_launcher.dart';

import 'the_pirate_bay.dart';

class QueryPage extends StatefulWidget{
  @override _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  Future<List<Torrent>> torrentRequest = Future<List<Torrent>>.value();
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(4),
            width: 800,
            child: TextField(
              style: Theme.of(context).textTheme.headline6.copyWith(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              cursorColor: Theme.of(context).scaffoldBackgroundColor,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Theme.of(context).scaffoldBackgroundColor,),
                contentPadding: const EdgeInsets.symmetric(vertical: 30.0),
                hintText: "Search torrent",
                hintStyle: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).scaffoldBackgroundColor,),
              ),
              onSubmitted: (query) {
                torrentRequest = ThePirateBay.search(query);
                setState((){});
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: torrentRequest,
        builder: (context, snapshot) {
          return
          snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator()) :
          snapshot.hasData ? Let<List<Torrent>>(
            let: snapshot.data,
            builder: (torrents) => Align(
              alignment: Alignment.center,
              child: Container(
                width: 800,
                child: ListView.builder(
                    itemBuilder: (context, index) => Let<Torrent>(
                      let: torrents[index],
                      builder: (torrent) => Card(
                        child: InkWell(
                          // onTap: ()=> navigator.push(MaterialPageRoute(builder: (_)=> TorrentDetailsPage(torrent: torrent,),),),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    child: Icon(torrent.categoryIcon),),
                                ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(torrent.name, maxLines: 1, softWrap: false, overflow: TextOverflow.fade, style: subtitle1,),),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(1),
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Text(torrent.size, style: bodyText2.copyWith(color: Colors.white),),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(1),
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Text(torrent.category, style: bodyText2.copyWith(color: Colors.white),),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(1),
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Text('Seeders: ' + torrent.seeders, style: bodyText2.copyWith(color: Colors.white),),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(1),
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Text('Leechers: ' + torrent.leechers, style: bodyText2.copyWith(color: Colors.white),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    color: Colors.deepPurple[300],
                                    icon: Icon(Icons.download_rounded),
                                    onPressed: ()=> launch(torrent.magnetUrl),
                                    tooltip: 'open magnet link',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    itemCount: torrents.length,),
              ),
            ),
          ) :
          Center(child: Icon(Icons.error),);
        }
      ),
    );
  }

  NavigatorState get navigator => Navigator.of(context);  // if doesn't work change back to direct call
  ThemeData get theme => Theme.of(context);
  TextStyle get bodyText2 => theme.textTheme.bodyText2;
  TextStyle get subtitle1 => theme.textTheme.subtitle1;
}