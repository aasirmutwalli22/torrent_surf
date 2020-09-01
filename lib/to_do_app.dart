import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: MyHomePage(title: 'To Do Example'),
  );
}

class MyHomePage extends StatefulWidget{
  final String title;
  const MyHomePage({Key key, this.title}) : super(key: key);
  @override _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<ToDo>> toDoRequest = new Future<List<ToDo>>.value(List<ToDo>());
  @override Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.grey[300],
              title: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                ),
                onSubmitted: (query) => setState(()=> toDoRequest = ToDoApi.fetchList()),
                textInputAction: TextInputAction.search,
              ),
            ),
            FutureBuilder(
              future: toDoRequest,
              builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting ? SliverToBoxAdapter(child: LinearProgressIndicator()) :
              snapshot.hasData ? SliverList(delegate: SliverChildBuilderDelegate((_, index) =>
                  ListTile(title: Text((snapshot.data as List<ToDo>)[index].title)),
                  childCount: (snapshot.data as List<ToDo>).length)
              ) :
              SliverToBoxAdapter(child: Text('No data found')),
            ),
          ],
        )
    );
  }
}
class ToDoApi {
  static final String _url = 'https://jsonplaceholder.typicode.com/todos/';
  static Future<String> _fetch() async => (await http.get(_url)).body;
  static Future<List<ToDo>> fetchList() async => (jsonDecode( await _fetch() ) as List).map((item) => ToDo.fromDynamic(item)).toList();
}

class ToDo{
  int userId;
  int id;
  String title;
  bool completed;
  ToDo(this.userId, this.id, this.title, this.completed);
  ToDo.fromDynamic(dynamic map) :
        userId = map['userId'],
        id = map['id'],
        title = map['title'],
        completed = map['completed'];
}