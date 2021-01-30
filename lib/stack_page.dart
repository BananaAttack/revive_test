import 'package:flutter/material.dart';

// 页面
import 'package:city_alliance/pages/Home/home.dart';
import 'package:city_alliance/pages/profile/profile.dart';

// 底部导航栏item组件
import 'components/tabbar/tabbar_item.dart';

class MyStackPage extends StatefulWidget {
  final currentIndex;
  MyStackPage({this.currentIndex: 0});
  @override
  MyStackPageState createState() => MyStackPageState(this.currentIndex);
}

class MyStackPageState extends State<MyStackPage> {
  var _currentIndex;
  MyStackPageState(index) {
    this._currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [Home(), Profile()],
      ),
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        // 选中item的颜色
        selectedItemColor: Color.fromARGB(255, 230, 126, 43),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          TabBarItem(Icons.location_on, "首页"),
          TabBarItem(Icons.person, "我的"),
        ],
      ),
    );
  }
}
