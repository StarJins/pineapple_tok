import 'package:flutter/material.dart';
import 'package:pineapple_tok/chatting_page/chatting_list_page.dart';
import 'package:pineapple_tok/credit_page/credit_page.dart';
import 'package:pineapple_tok/friend_page/friend_page.dart';

class MainPage extends StatefulWidget {
  final int currentId;
  MainPage(this.currentId, {Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _getBodyPage(),
      bottomNavigationBar: SizedBox(
        height: 60.0,
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _getAppbarTitle(),
      automaticallyImplyLeading: false,
      elevation: 0.0,
    );
  }

  Widget _getAppbarTitle() {
    if (_selectedPageIdx == 0) {
      return Text('friend page');
    }
    else if (_selectedPageIdx == 1) {
      return Text('chatting page');
    }
    else {
      return Text('credit page');
    }
  }

  Widget _getBodyPage() {
    if (_selectedPageIdx == 0) {
      return FriendPage(widget.currentId);
    }
    else if (_selectedPageIdx == 1) {
      return ChattingPage(widget.currentId);
    }
    else {
      return CreditPage();
    }
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
