import 'package:flutter/material.dart';
import 'package:torrent_surf/query_page.dart';
import 'package:torrent_surf/torrent_search_page.dart';

void main() => runApp(MyApp());

AppBarTheme searchBarTheme(Brightness brightness) => AppBarTheme(color: brightness == Brightness.dark ?  Colors.grey[800] : Colors.grey[200],) ;

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData.light().copyWith(
      primaryColor: Colors.deepPurple[400],
      accentColor: Colors.red[500],
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme.of(context).copyWith(
        // color: Colors.white
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      primaryColor: Colors.indigo[300],
      accentColor: Colors.red[300],
      scaffoldBackgroundColor: Colors.grey[900],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme.of(context).copyWith(
        elevation: 0,
        color: Colors.grey[800],
        brightness: Theme.of(context).brightness,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white,),
      ),
    ),
    home: QueryPage(),
  );
}