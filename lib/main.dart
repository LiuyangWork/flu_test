import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';

//HttpClient
import 'dart:io';

//强大的http请求库
import 'package:dio/dio.dart';

AnimationController controller;
CurvedAnimation curve;



// void main() => runApp(new MyApp());
void main(List<String> args) {
  runApp(new MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // final word = new WordPair.random();

    // return new MaterialApp(
    //   title: 'Welcome to Flutter',

    //   home: new Scaffold(
    //     appBar: new AppBar(
    //       title: new Text('Welcome to Flutter'),
    //     ),
    //     body: new Center(
    //       // child: new Text('Hello World'),
    //       // child: new Text(word.asPascalCase),
    //       child: new RandomWords(),
    //     ),

    //   ),
    // );

    return new MaterialApp(
      title: 'Startup Name Generator',
      
      theme: new ThemeData(
        primaryColor: Colors.blue[200]
      ),

      home: new RandomWords(),

    );

  }
}

class RandomWords extends StatefulWidget {
  @override
    createState() => new RandomWordsState();
}

//state
class RandomWordsState extends State<RandomWords> {
  List widgets = [];

  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();

  final _briggerFont = const TextStyle(fontSize: 18);

  @override
    void initState() {
      // TODO: implement initState
      super.initState();

      print('init state');
      //load data
    }

  void _pushSaved(){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _briggerFont
                ),
              );
            },
          );

          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved suggesstions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16),

      // itemCount: 5,

      itemBuilder: (context, i) {
        if (i.isOdd) 
          return new Divider();
        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }


  Widget _buildRow(WordPair pair) {

    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      
      title: new Text(
        pair.asPascalCase,
        style: _briggerFont,
      ),
      //心形图标
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      //点击事件
      onTap: () {
        setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  }
                  else {
                    _saved.add(pair);
                  }
                });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // final word = new WordPair.random();
    // return new Text(word.asPascalCase);

    // return MyScaffold();

      return createScaffold();
  }

// 创建主界面 Scaffold是Material中主要的布局组件
Scaffold createScaffold() {
  return new Scaffold(

    // 导航栏
    appBar: new AppBar(

      // 左按钮
      leading: new IconButton(
        icon: new Icon(Icons.menu),
        tooltip: 'Navigation name',
        onPressed: _pushSaved,
      ),

      // 导航栏标题
      title: new Text('Startup name generator'),

      // 右按钮
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.search),
          onPressed: _pushSaved,
          tooltip: 'search',
        ),
      ],
    ),

    // 主界面的body
    body: _buildSuggestions(),

    floatingActionButton: new FloatingActionButton(
      tooltip: 'Add',
      child: new Icon(Icons.add),
      onPressed: _pushSaved,
    ),


  );
}

  showLoadingDialog() {

  }

  //异步任务
  loadData() async {
    String url = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(url);
    //调用 setState() 来更新 UI，这会触发 widget 子树的重建，并更新相关数据
    setState(() {
        // widgets = List.from(widgets);
          widgets = json.decode(response.body);
        });
  }

}

//httpClient
httpClient_get() async {
  var httpClient = new HttpClient();
  var uri = new Uri.http(
      'example.com', '/path1/path2', {'param1': '42', 'param2': 'foo'});
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(utf8.decoder).join();
  
}

class MyButton extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new GestureDetector(
        onTap: (){
          print('MyButton tapped');
        },
        child: new Container(
          height: 36,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5),
            color: Colors.lightGreen[50]
          ),

          child: new Center(
            child: new Text('Engage_button'),
          )
        ),
      );
    }
}

//自定义bar
class MyAppBar extends StatelessWidget {
  
// widget 子类中的字段往往都定义为 final
  final Widget title;

  MyAppBar(this.title);

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
        height: 88, //逻辑像素
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: new BoxDecoration(color: Colors.blue[500]),

        //Row是水平方向的线性布局(linear layout)
        child: new Row(
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.menu),
              tooltip: 'Navigaion menu',
              padding: const EdgeInsets.symmetric(vertical: 50),
              onPressed: null,
            ),

            new Expanded(
              child: title,
            ),

            new IconButton(
              icon: new Icon(Icons.search),
              tooltip: 'Search',
              padding: const EdgeInsets.symmetric(vertical: 50),
              onPressed: null,
            ),

          ],

        ),
      );
    }
}

class MyScaffold extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Material(

        //Column 垂直方向的线性布局
        child: new Column(
          children: <Widget>[
            new MyAppBar(
              new Text(
                'title123',
                style: Theme.of(context).primaryTextTheme.title,
              ),
            ),

            new Expanded(
              child: new Center(
                child: new Text('hello,world'),
              ),
            ),
          ],
        ),
      );
    }
}

class CustomScafford extends Scaffold {
  
}