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

    return new MaterialApp(
      title: 'Startup Name Generator',
      
      theme: new ThemeData(
        primaryColor: Colors.red, accentColor: Colors.redAccent
      ),

      home: new RandomWords(),

      // 静态路由
      routes: <String, WidgetBuilder> {
        '/page2': (BuildContext context) => new page2('hello'),
      },

    );

  }
}

class RandomWords extends StatefulWidget {
  @override
    createState() => new RandomWordsState();
}

//state
class RandomWordsState extends State<RandomWords> {
  // List
  List widgets = [];

  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();

  final _briggerFont = const TextStyle(fontSize: 18);

  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();

      print('init state');

      //l oad data
      _suggestions.addAll(generateWordPairs().take(15)); 

      // 监听是否滑到底部
      _scrollController.addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          print('load more');
          _handleLoadMore();
        }
      });
    }

  // 点击事件
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

    Scaffold;
    // .of(context).showSnackBar(new)
    print('back');
  }

  Widget _buildSuggestions() {

    // 通过 RefreshIndicator 实现下拉刷新
    return new RefreshIndicator(
      child: new ListView.builder(
        padding: const EdgeInsets.all(16),
        // item的数量
        itemCount: _suggestions.length + 1,

        // 构建item
        itemBuilder: (BuildContext context, int index) {
          // 最后一行显示loading
          if (index == _suggestions.length) {
            // return _buildLoadingText();
            return _buildLoadingIndicator();
          }
          else {
            // if (index.isOdd) 
          //   return new Divider();
          // final index = i ~/ 2;

          // if (index >= _suggestions.length) {
          //   _suggestions.addAll(generateWordPairs().take(10));
          // }

          return _buildRow(_suggestions[index]);

          // 实现滑动关闭: 将每个item包装在Dismissible Widget中
          // return new Dismissible(
          //   background: new Container(color: Colors.red,),

          //   // Each Dismissible must contain a Key. Keys allow Flutter to
          //   // uniquely identify Widgets.
          //   key: new Key(_suggestions[index].asPascalCase),
          //   // We also need to provide a function that will tell our app
          //   // what to do after an item has been swiped away.
          //   onDismissed: (direction) {
          //     setState(() {
          //       // Show a snackbar! This snackbar could also contain "Undo" actions.
          //       Scaffold.of(context).showSnackBar(
          //           new SnackBar(content: new Text("${_suggestions[index].asPascalCase} dismissed"))
          //       );

          //       // Remove the item from our data source
          //       _suggestions.removeAt(index);
          //       _saved.remove(_suggestions[index]);
          //     });
          //   },
          //   child: _buildRow(_suggestions[index])
          // );
          }
        },
        controller: _scrollController,
      ),

      onRefresh: _handleRefresh,
    );
  }

  // 处理下拉刷新
  Future<Null> _handleRefresh() async{
    await Future.delayed(Duration(seconds: 2), (){
      setState(() {
          _suggestions.clear();
          _suggestions.addAll(generateWordPairs().take(15));

          return null;
        });
    });

  }
  // 处理上滑加载
  Future _handleLoadMore() async{
    if (!isLoading) {
      setState(() =>isLoading = true);

      Future.delayed(Duration(seconds: 2), () {
      setState(() {
          _suggestions.addAll(generateWordPairs().take(5));

          isLoading = false;
        });
    });
    }
  }


  Widget _buildRow(WordPair pair) {

    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        'name ${pair.asPascalCase}',
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

  Widget _buildLoadingText() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Text('loading'),
        ),
      ),
      color: Colors.white70,
    );
  }

  Widget _buildLoadingIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
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

      drawer: new Drawer(
        child: new Column(
          children: <Widget>[

            new UserAccountsDrawerHeader(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new NetworkImage('https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1543226054121&di=e403210dd71ede70a777c6dfb854275a&imgtype=0&src=http%3A%2F%2Fp3.pstatp.com%2Forigin%2Ftemai%2FFrAXHctZQhuuvjSKUxIO_Ov8I-G9.png')
                  )
                ),
                accountName: Text('Timor'),
                accountEmail: Text('timor@xiaomi.com'),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: new NetworkImage('https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1543294072314&di=dfebe8be0acec2f8ec0cda92133818a6&imgtype=0&src=http%3A%2F%2Fm.360buyimg.com%2Fn12%2Fg16%2FM00%2F0C%2F01%2FrBEbRVOFUCEIAAAAAADF9qGxgs8AACWDAHBzKQAAMYO004.jpg%2521q70.jpg'),
                ),
            ),

            new ListTile(
              leading: new Icon(Icons.refresh), 
              title: Text('刷新'),
              onTap: _pushSaved,
              ),
            new ListTile(
              leading: new Icon(Icons.help), 
              title: Text('帮助'),
            ),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: Text('设置'),
            ),

            new MyListItem(Icons.star, '收藏'),
            new MyListItem(Icons.send, '反馈'),



          ],
        ),
      ),

      // 顶部导航栏
      appBar: new AppBar(

        // // 左按钮
        // leading: new IconButton(
        //   icon: new Icon(Icons.menu),
        //   tooltip: 'Navigation name',
        //   onPressed: _pushSaved,
        // ),

        // 导航栏标题
        title: new Text('Startup name generator'),

        // 右按钮
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),

            onPressed: () {
              // 静态路由的方式跳转
              // Navigator.of(context).pushNamed('/page2');


              // 动态路由的方式跳转
              Future future = Navigator.of(context).push(
                new PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return page2('dynamic route page');
                  }
                )
              );

              future.then((onValue){
                if (onValue != null) {
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: new Text(onValue),
                      actions: <Widget>[
                        FlatButton(
                          child: new Text('done'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                    ],);
                  }
                );
                }
              });
            },

            tooltip: 'search',
          ),
        ],
      ),
 
      // 主界面的body
      body: new Center(
        // 手势
        child: GestureDetector(
          child: _buildSuggestions(),

          onTap: () {
            print('onTap');
          },

          onLongPress: () {
            print('longPress');
          },

          onDoubleTap: () {
            print('doubleTap');
          },
        ),
      ), 

      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: Text('首页')
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.message, size: 30, color: Colors.yellow,), title: Text('消息')
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('我的')
              // icon: Icon(new IconData(0xeb8b,fontFamily: "Schyler"),size: 30.0,color: Colors.blueAccent,)
            ),
          ],

          fixedColor: Colors.red,
          currentIndex: 0,
        ),

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

class MyListItem extends StatelessWidget {
  IconData iconData;
  String title;

  MyListItem(this.iconData, this.title);

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
              padding: const EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(
                    color: Colors.grey,
                )),
              ),
              child: new Row(children: <Widget>[
                new Icon(
                  iconData,
                  color: Colors.lightBlueAccent,
                ),
                new Expanded(
                  child: new Text(
                    title,
                    textAlign: TextAlign.right,
                  ),
                )
              ]
            ),
          );
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

class CustomScaffold extends Scaffold {
  
}

//自定义button
class MyButton extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new GestureDetector (
        onTap: (){
          print('MyButton tapped');
        },

        child: new Container(
          height: 36,
          padding: const EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5),
            color: Colors.red[500],
          ),
          child: new Center(
            child: new Text('Engage_button'),
          ),
        ),
        
      );//d

    }
}

class page2 extends StatelessWidget {
  final String title;

  page2(this.title);

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        appBar: AppBar(
          title: new Text('page2'),
        ),

        body: new Center(
          child: new Column(
            children: <Widget>[
               new Text(
                title,
                style: new TextStyle(fontSize: 25),
              ),

              new RaisedButton(
                child: new Text('返回'),

                onPressed: () {
                  Navigator.of(context).pop('返回数据：hello world');
                },
              )
            ],
          ),
        ),
      );
    }
}