import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pineapple_tok/chatting_page/chatting_list_page.dart';
import 'package:pineapple_tok/credit_page/credit_page.dart';
import 'package:pineapple_tok/friend_page/friend_page.dart';
import 'package:pineapple_tok/friend_page/new_friend_page.dart';

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
      appBar: _getAppbar(),
      body: _getBodyPage(),
      bottomNavigationBar: SizedBox(
        height: 60.0,
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  AppBar _getAppbar() {
    if (_selectedPageIdx == 0) {
      return AppBar(
        title: Text('friend page'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: NewFriendPage(),
                  ),
                );
              },
              icon: Icon(Icons.person_add_alt_1),
              splashRadius: 20.0,
            ),
          ),
        ],
      );
    }
    else if (_selectedPageIdx == 1) {
      return AppBar(
        title: Text('chatting page'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      );
    }
    else {
      return AppBar(
        title: Text('credit page'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      );
    }
  }

  Widget _getBodyPage() {
    if (_selectedPageIdx == 0) {
      return FriendPage();
    }
    else if (_selectedPageIdx == 1) {
      return ChattingPage();
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
