import 'package:flutter/material.dart';
import 'package:torrent_surf/torrent_search_page.dart';

AppBarTheme searchBarTheme(Brightness brightness) => AppBarTheme(color: brightness == Brightness.dark ?  Colors.grey[800] : Colors.grey[200],) ;

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData.light().copyWith(
        primaryColor: Colors.indigo[500],
        accentColor: Colors.red[500],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme.of(context).copyWith(color: Colors.blue,
            textTheme: Theme.of(context).textTheme.apply(

            ),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.red,
            )
        )
    ),
    darkTheme: ThemeData.dark().copyWith(
      primaryColor: Colors.indigo[300],
      accentColor: Colors.red[300],
      scaffoldBackgroundColor: Colors.grey[900],
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: TorrentSearchPage(),
  );
}