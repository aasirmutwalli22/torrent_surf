import 'package:flutter/material.dart';
import 'package:flutter_customs/flutter_customs.dart';
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
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: FutureBuilder(
        future: torrentRequest,
        builder: (context, snapshot) => CustomScrollView(
          primary: true,
          slivers: <Widget>[
            SliverPadding(
              padding: /*searchFocused ? EdgeInsets.all(0) : EdgeInsets.symmetric(horizontal: 16, vertical: 8) */EdgeInsets.all(16),
              sliver: SliverAppBar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark ?  Colors.grey[800] : Colors.grey[200],
                toolbarHeight: 50,
                collapsedHeight: 51,
                shape: RoundedRectangleBorder(
                  borderRadius: /*searchFocused ? BorderRadius.zero : */ BorderRadius.circular(8),),
                automaticallyImplyLeading: false,
                floating: true,
                title: FocusScope(
                  child: Focus(
                    onFocusChange: (focused) => setState(() => searchFocused = focused),
                    child: TextField(
                      maxLengthEnforced: true,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: Theme.of(context).accentColor,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.search),
                        hintText: "Search torrent",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (query) => setState(()=> torrentRequest = ThePirateBay.searchTorrents(query)),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ),
              ),
            ),
            snapshot.connectionState == ConnectionState.waiting ? SliverToBoxAdapter(child: LinearProgressIndicator()) :
            snapshot.hasData ? (snapshot.data as List<Torrent>).let((torrents) => torrents.length > 0 ? SliverList(
              delegate: SliverChildBuilderDelegate((_, index) => torrents[index].let((torrent) =>
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
                              child: Text(torrent.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle1,),),
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
              ), childCount: torrents.length,),) :
            SliverToBoxAdapter(child: ListTile(title: Text('No Results'),),),) :
            SliverToBoxAdapter(child: ListTile(title: Text('Query failed'),),),
          ],
        ),
      ),
    ),
  );
}