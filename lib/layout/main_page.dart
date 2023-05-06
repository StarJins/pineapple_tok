import 'package:flutter/material.dart';
import 'package:pineapple_tok/main.dart' as page;

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: page.pageList[this._selectedPageIdx]!.pageWidget,
      bottomNavigationBar: SizedBox(
        height: 60.0,
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('${page.pageList[this._selectedPageIdx]!.pageName}'),
      automaticallyImplyLeading: false,
      elevation: 0.0,
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0.1,
      backgroundColor: Colors.white54,
      selectedFontSize: 0.0,
      unselectedFontSize: 0.0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.black54,
      unselectedItemColor: Colors.black12,

      currentIndex: this._selectedPageIdx,
      onTap: (int idx) {
        setState(() {
          this._selectedPageIdx = idx;
        });
      },

      items: [
        _myBottomNavigationBarItem(Icon(Icons.person, size: 40.0,), 'friend'),
        _myBottomNavigationBarItem(Icon(Icons.chat, size: 40.0,), 'chatting'),
        _myBottomNavigationBarItem(Icon(Icons.menu, size: 40.0,), 'credit'),
      ],
    );
  }

  BottomNavigationBarItem _myBottomNavigationBarItem(Icon icon, String label) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }
}
