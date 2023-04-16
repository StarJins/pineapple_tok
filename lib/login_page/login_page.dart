import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // login page에서만 snack bar가 보일 수 있도록 ScaffoldMessenger 추가
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.close),
            ),
          ],
          elevation: 0.0,
        ),
        body: _BuildBody(),
      ),
    );
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody({super.key,});

  @override
  Widget build(BuildContext context) {
    // body 전체 배경색을 위해 Container를 infinity로 지정
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.yellow[300],
      // 배경 클릭 시 text field에 있는 focus를 없애 키보드를 사라지게 해줌
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // 전체 폰 화면에서 가운데가 될 수 있게 flex를 조절
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            Expanded(
              child: _MainScreen(),
              flex: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _MainScreen extends StatelessWidget {
  const _MainScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    // 키보드 올라왔을 때 자동으로 스크롤 될 수 있게 해주는 widget
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Image.asset(
              'assets/login_pineapple.png',
              height: 200.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController idTextController = TextEditingController();
  TextEditingController pwTextController = TextEditingController();
  bool? autoLoginFlag = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your ID',
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: TextInputType.emailAddress,
          controller: idTextController,
        ),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your Password',
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: pwTextController,
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: double.infinity,
          height: 60.0,
          // login page에서만 snack bar가 보일 수 있도록 Builder 추가
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                ),
                onPressed: () {
                  setState(() {
                    if (_checkIdPw(context, idTextController.text, pwTextController.text)) {
                      if (autoLoginFlag! == false) {
                        idTextController.text = '';
                        pwTextController.text = '';
                      }
                    }
                  });
                },
                child: Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Checkbox(
              value: autoLoginFlag,
              onChanged: (bool? newValue) {
                setState(() {
                  autoLoginFlag = newValue;
                });
              },
              checkColor: Colors.black54,
              activeColor: Colors.white,
            ),
            Text(
              '자동로그인',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _checkIdPw(BuildContext context, String id, String pw) {
    final dbId = 'test';
    final dbPw = '1234';
    final duration = 2;
    if (dbId != id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ID가 올바르지 않습니다.'),
          duration: Duration(seconds: duration),
          backgroundColor: Colors.lightBlue,
        ),
      );
      return false;
    }
    else if (dbPw != pw) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PW가 올바르지 않습니다.'),
          duration: Duration(seconds: duration),
          backgroundColor: Colors.lightBlue,
        ),
      );
      return false;
    }
    else {
      Navigator.pushNamed(context, '/friend_page');
      return true;
    }
  }
}