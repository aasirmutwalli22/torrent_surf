import 'dart:convert';
import 'dart:math';
import 'package:flutter_customs/flutter_customs.dart';
import 'package:http/http.dart' as http;
class ThePirateBay{
  static String _serverUrl = 'https://apibay.org/';
  static String _searchUrl = _serverUrl + 'q.php?q=';
  static String _listFilesUrl = _serverUrl + 'f.php?id=';
  static List<String> _suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  static List<String> _trackers = [
    'udp://tracker.coppersurfer.tk:6969/announce',
    'udp://9.rarbg.to:2920/announce',
    'udp://tracker.opentrackr.org:1337',
    'udp://tracker.internetwarriors.net:1337/announce',
    'udp://tracker.leechers-paradise.org:6969/announce',
    'udp://tracker.coppersurfer.tk:6969/announce',
    'udp://tracker.pirateparty.gr:6969/announce',
    'udp://tracker.cyberia.is:6969/announce',];
  static Map<int, IconData> _categoriesIcons = {
    0 : Icons.dashboard,
    1 : Icons.audiotrack,
    2 : Icons.movie,
    3 : Icons.apps,
    4 : Icons.games,
    5 : Icons.wc,
    6 : Icons.dashboard,
    101: Icons.album,
    102: Icons.library_music,
    103: Icons.audiotrack,
    104: Icons.album,
    199: Icons.dashboard,
    201: Icons.movie,
    202: Icons.movie,
    203: Icons.slideshow,
    204: Icons.movie,
    205: Icons.live_tv,
    206: Icons.pan_tool,
    207: Icons.hd,
    208: Icons.hd,
    209: Icons.threed_rotation,
    299: Icons.dashboard,
    301: Icons.desktop_windows,
    302: Icons.desktop_mac,
    303: Icons.devices_other,
    304: Icons.pan_tool,
    305: Icons.phone_iphone,
    306: Icons.android,
    399: Icons.devices_other,
    401: Icons.computer,
    402: Icons.desktop_mac,
    403: Icons.gamepad,
    404: Icons.gamepad,
    405: Icons.gamepad,
    406: Icons.pan_tool,
    407: Icons.phone_iphone,
    408: Icons.android,
    499: Icons.devices_other,
    501: Icons.movie,
    502: Icons.movie,
    503: Icons.insert_photo,
    504: Icons.gamepad,
    505: Icons.hd,
    506: Icons.movie,
    599: Icons.dashboard,
    601: Icons.description,
    602: Icons.description,
    603: Icons.insert_photo,
    604: Icons.insert_photo,
    605: Icons.print,
    699: Icons.dashboard,
  };
  static Map<int, String> _categories = {
    0 : "",
    1 : "Audio",//
    2 : "Video",//
    3 : "Applications",//
    4 : "Games",//
    5 : "Porn",//
    6 : "Others",//
    101: "Music",//
    102: "Audio books",//
    103: "Sound clips",//
    104: "FLAC",//
    199: "Others",//
    201: "Movies",//
    202: "Movies DVDR",//
    203: "Music videos",//
    204: "Movie clips",//
    205: "TV shows",//
    206: "Handheld",//
    207: "HD movies",//
    208: "HD TV shows",//
    209: "3D",//
    299: "Other",//
    301: "Windows",//
    302: "Mac/Apple",//
    303: "Unix",//
    304: "Handheld",//
    305: "IOS(iPad/iPhone)",//
    306: "Android",//
    399: "Other OS",//
    401: "PC",//
    402: "Mac/Apple",//
    403: "PSx",//
    404: "XBOX360",//
    405: "Wii", //
    406: "Handheld",//
    407: "IOS(iPad/iPhone)",//
    408: "Android",//
    499: "Other Os",//
    501: "Movies",  //
    502: "Movies DVDR",//
    503: "Pictures",//
    504: "Games",//
    505: "HD Movies",//
    506: "Movie clips",//
    599: "Other",//
    601: "E books",//
    602: "Comics",//
    603: "Pictures",//
    604: "Covers",//
    605: "Physibles",//
    699: "Other"//
  };

  static Future<String> _listFiles(String id) async => (await http.get(_listFilesUrl + Uri.encodeComponent(id))).body;
  static Future<String> _search(String query) async => (await http.get(_searchUrl + Uri.encodeComponent(query))).body;
  static Future<List<Torrent>> searchTorrents(String query) async =>
      (jsonDecode(await _search(query)) as List).
      map((torrent) => new Torrent(
        added: torrent['added'],
        category: _categories[int.parse(torrent['category'])],
        categoryIcon: _categoriesIcons[int.parse(torrent['category'])],
        id: torrent['id'],
        leechers: torrent['leechers'],
        magnetUrl: _magnetUrl(torrent['info_hash'], torrent['name']),
        name: torrent['name'],
        num_files: torrent['num_files'],
        seeders: torrent['seeders'],
        size: _formatBytes(int.parse(torrent['size']), 2),
        username: torrent['username'],),).
      toList();
  static Future<List<TorrentContent>> fileList(String id) async =>
      (jsonDecode(await _listFiles(id)) as List).
      map((file) => new TorrentContent(
        name: file['name']['0'],
        size: _formatBytes(int.parse(file['size']['0']), 2),),).
      toList();

  static String _formatBytes(int bytes, int decimals) => bytes <= 0 ? "0 B" :
  (log(bytes) / log(1024)).floor().let((it) => ((bytes / pow(1024, it)).toStringAsFixed(decimals)) + _suffixes[it]);

  static String _magnetUrl(String infoHash, String name) =>
      'magnet:?xt=urn:btih:' + infoHash + '&dn=' + Uri.encodeComponent(name) + _getTrackers();

  static String _getTrackers() => ''.let((it) {
    for(String tracker in _trackers) it += '&tr=' + Uri.encodeComponent(tracker); return it; });

// static List<IconData> _categoryIcon = [
//   Icons.description,
//   Icons.music_note,
//   Icons.movie,
//   Icons.computer,
//   Icons.games,
//   Icons.wc,
//   Icons.picture_as_pdf
// ];
// static int _categoryIconsIndex(int _category) =>
//     [1, 101, 102, 103, 104, 199].contains(_category)                          ? 1 :   //music
//     [2, 201, 202, 203, 204, 205, 206, 207, 208, 209, 299].contains(_category) ? 2 :   //video //movies//hd videos
//     [3, 301,  302, 303, 304, 305, 306, 399].contains(_category)               ? 3 :   //applications
//     [4, 401, 402, 403, 404, 405, 406, 407, 408, 499].contains(_category)      ? 4:    //games
//     [5, 501, 502, 503, 504, 506, 599].contains(_category)                     ? 5:    //porn
//     [6, 601, 602, 603, 604, 605, 699].contains(_category)                     ? 6:    //others
//     0;
// String formatBytes(int bytes, int decimals) {
//   const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
//   //if (bytes <= 0) return "0 B";
//   var i = (log(bytes) / log(1024)).floor();
//   return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
//       ' ' + suffixes[i];
// }
// static String _sizes(String size)=> double.parse(size).let((bytes) =>
//     bytes >= 1125899906842624 ? (bytes / 1125899906842624).toStringAsFixed(2) + "PB" :
//     bytes >= 1099511627776 ? (bytes / 1099511627776).toStringAsFixed(2) + "TB" :
//     bytes >= 1073741824 ?  (bytes / 1073741824).toStringAsFixed(2) + "GB":
//     bytes >= 1048576 ? (bytes / 1048576).toStringAsFixed(2) + "MB" :
//     bytes >= 1024 ?  (bytes/1024).toStringAsFixed(2) + "KB":
//     bytes.toStringAsFixed(2) + "B");
// static String _getTrackers() =>
//     '&tr=' + Uri.encodeComponent('udp://tracker.coppersurfer.tk:6969/announce') +
//     '&tr=' + Uri.encodeComponent('udp://9.rarbg.to:2920/announce') +
//     '&tr=' + Uri.encodeComponent('udp://tracker.opentrackr.org:1337') +
//     '&tr=' + Uri.encodeComponent('udp://tracker.internetwarriors.net:1337/announce') +
//     '&tr=' + Uri.encodeComponent('udp://tracker.leechers-paradise.org:6969/announce') +
//     '&tr=' + Uri.encodeComponent('udp://tracker.coppersurfer.tk:6969/announce') +
//     '&tr=' + Uri.encodeComponent('udp://tracker.pirateparty.gr:6969/announce') +
//     '&tr=' + Uri.encodeComponent('udp://tracker.cyberia.is:6969/announce');
}
class Torrent{
  String added;
  String category;
  IconData categoryIcon;
  String id;
  String leechers;
  String magnetUrl;
  String name;
  String num_files;
  String seeders;
  String size;
  String username;
  Torrent({
    this.added,
    this.category,
    this.categoryIcon,
    this.id,
    this.leechers,
    this.magnetUrl,
    this.name,
    this.num_files,
    this.seeders,
    this.size,
    this.username,});
  Torrent.fromDynamic(dynamic map) :
        added = map["added"],
        category = map["category"],
        categoryIcon = map["categoryIcon"],
        id = map["id"],
        leechers = map["leechers"],
        magnetUrl = map['magnetUrl'],
        name = map["name"],
        num_files = map["num_files"],
        seeders = map["seeders"],
        size = map["size"],
        username = map["username"];
  toMap() => {
    'added' : added,
    'category' : category,
    'categoryIcon' : categoryIcon,
    'id' : id,
    'leechers' : leechers,
    'magnetUrl' : magnetUrl,
    'name' : name,
    'num_files': num_files,
    'seeders' : seeders,
    'size' : size,
    'username' : username
  };
}
class TorrentContent {
  String name;
  String size;
  TorrentContent({this.name, this.size});
  TorrentContent.fromDynamic(dynamic map):
    name = map['name']['0'],
    size = map['size']['0'];
}