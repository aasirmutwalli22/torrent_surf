import 'package:flutter/material.dart';
import 'package:dart_standard/dart_standard.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'the_pirate_bay.dart';
import 'torrent_details_page.dart';

class TorrentSearchPage extends StatefulWidget {
  TorrentSearchPage({Key key, this.title}) : super(key: key);
  final String title;
  @override _TorrentSearchPageState createState() => _TorrentSearchPageState();
}

class _TorrentSearchPageState extends State<TorrentSearchPage> {
  Future<List<Torrent>> torrentRequest = Future<List<Torrent>>.value(List<Torrent>());
  bool searchFocused = false;
  @override Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ),
    child: Scaffold(
      body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, enabled) => <Widget>[
              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverAppBar(
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ?  Colors.grey[800] : Colors.grey[200],
                  toolbarHeight: 50,
                  collapsedHeight: 51,
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4),),
                  //automaticallyImplyLeading: false,
                  floating: true,
                  pinned: false,
                  title: TextField(
                    autofocus: false,
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration.collapsed(
                      hintText: "Search torrent",),
                    onSubmitted: (query) => setState(()=> torrentRequest = ThePirateBay.searchTorrents(query)),
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ),
            ],
            body: FutureBuilder(
              future: torrentRequest,
              builder:(context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator()) :
              snapshot.hasData ? (snapshot.data as List<Torrent>).let((torrents) => torrents.length > 0 ?
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: torrents.length,
                itemBuilder: (context, index) => torrents[index].let((torrent) =>
                torrent.id.toInt() == 0 ? ListTile(title: Text(torrent.name),) : InkWell(
                  onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TorrentDetailsPage(torrent: torrent,),),),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(child: Icon(torrent.categoryIcon),),),
                        Flexible(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(torrent.name, maxLines: 1, softWrap: false, overflow: TextOverflow.fade, style: Theme.of(context).textTheme.subtitle1,),),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Seeders: ' + torrent.seeders, style: Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).primaryColor,),),
                                    Text('Leechers: ' + torrent.leechers, style: Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).accentColor,),)
                                  ],),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(torrent.category,),
                                    Text(torrent.size,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.open_in_new),
                            onPressed: ()=> launch(torrent.magnetUrl),
                            tooltip: 'Magnet',
                            color: Colors.deepPurple[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
              ) :
              ListTile(title: Text('No Results'),),) :
              ListTile(title: Text('Query failed'),),
            ),
          )
      ),
    ),
  );
}