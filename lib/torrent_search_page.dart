import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_standard/dart_standard.dart';
import 'package:flutter_boost/let.dart';
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
    value: statusBarStyle,
    child: Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, enabled) => <Widget>[searchBar,],
          body: FutureBuilder(
            future: torrentRequest,
            builder:(context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator()) :
            snapshot.hasData ? Let<List<Torrent>>(
              let: snapshot.data,
              builder: (torrents) => torrents.length > 0 ?
              ListView.builder(
                itemCount: torrents.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Let<Torrent>(
                  let: torrents[index],
                  builder : (torrent) => torrent.id.toInt() == 0 ?
                  ListTile(title: Text(torrent.name),) :
                  InkWell(
                    onTap: ()=> navigator.push(MaterialPageRoute(builder: (_)=> TorrentDetailsPage(torrent: torrent,),),),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(child: Icon(torrent.categoryIcon),),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Seeders: ' + torrent.seeders, style: bodyText2.copyWith(color: primaryColor,),),
                                      Text('Leechers: ' + torrent.leechers, style: bodyText2.copyWith(color: accentColor,),)
                                    ],
                                  ),
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
                              color: Colors.deepPurple[300],
                              icon: Icon(Icons.open_in_new),
                              onPressed: ()=> launch(torrent.magnetUrl),
                              tooltip: 'Magnet',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ) : ListTile(title: Text('No Results'),),
            ) : ListTile(title: Text('Query failed'),),
          ),
        ),
      ),
    ),
  );

  SystemUiOverlayStyle get statusBarStyle => SystemUiOverlayStyle(
    statusBarBrightness: statusBarBrightness,
    statusBarColor: backgroundColor,
    statusBarIconBrightness: statusBarBrightness,
    systemNavigationBarColor: backgroundColor,
  );
  Widget get searchBar => SliverPadding(
    padding: EdgeInsets.all(10),
    sliver: SliverAppBar(
      //automaticallyImplyLeading: false,
      backgroundColor: darkMode ?  Colors.grey[800] : Colors.grey[200],
      collapsedHeight: 51,
      floating: true,
      pinned: false,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4),),
      title: TextField(
        autofocus: false,
        cursorColor: accentColor,
        decoration: InputDecoration.collapsed(hintText: "Search torrent",),
        // onSubmitted: (query) => setState(()=> torrentRequest = ThePirateBay.searchTorrents(query)),
        textInputAction: TextInputAction.search,
      ),
      toolbarHeight: 50,
    ),
  );

  NavigatorState get navigator => Navigator.of(context);  // if doesn't work change back to direct call
  ThemeData get theme => Theme.of(context);
  TextStyle get bodyText2 => theme.textTheme.bodyText2;
  TextStyle get subtitle1 => theme.textTheme.subtitle1;
  bool get darkMode => theme.brightness == Brightness.dark;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Brightness get statusBarBrightness => darkMode ? Brightness.light : Brightness.dark;
  Color get primaryColor => theme.primaryColor;
  Color get accentColor => theme.accentColor;
}