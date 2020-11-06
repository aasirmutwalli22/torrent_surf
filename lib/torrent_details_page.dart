import 'package:flutter/material.dart';
import 'package:dart_standard/dart_standard.dart';
import 'package:flutter/services.dart';
import 'the_pirate_bay.dart';

class TorrentDetailsPage extends StatefulWidget{
  final Torrent torrent;
  TorrentDetailsPage({Key key, this.torrent}) : super(key: key);
  @override
  _TorrentDetailsPageState createState() => _TorrentDetailsPageState();
}

class _TorrentDetailsPageState extends State<TorrentDetailsPage> {
  Future<List<TorrentContent>> fileList = new Future<List<TorrentContent>>.value(List<TorrentContent>());

  @override void initState() {
    super.initState();
    setState(() {
      fileList = ThePirateBay.fileList(widget.torrent.id);
    });
  }

  @override Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ),
    child: Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(title: Text(widget.torrent.name, style: Theme.of(context).textTheme.headline6,),),
          FutureBuilder(
            future: fileList,
            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ?
            LinearProgressIndicator() :
            snapshot.hasData ? (snapshot.data as List<TorrentContent>).let((files) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Available files'),
                  dense: true,),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: files.length,
                  itemBuilder: (context, index) => files[index].let((file) => ListTile(
                    leading: Icon(Icons.attach_file),
                    onTap: (){},
                    title: Text(file.name,),
                    subtitle: Text(file.size,),),),),
              ],),) :
            ListTile(title: Text('No files available'),),
          ),
        ],
      ),
    ),
  );
}
