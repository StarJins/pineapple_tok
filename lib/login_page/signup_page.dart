import 'package:flutter/material.dart';
import 'package:pineapple_tok/data/account.dart';
import 'package:tuple/tuple.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // login page에서만 snack bar가 보일 수 있도록 ScaffoldMessenger 추가
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
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
            // TODO: stack 활용해서 위치 조정해보기
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
            SizedBox(
              height: 40.0,
            ),
            SignUpForm(),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController idTextController = TextEditingController();
  TextEditingController pwTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MyTextField('Enter your name', TextInputType.text, nameTextController, false),
        SizedBox(
          height: 10.0,
        ),
        _MyTextField('Enter your ID', TextInputType.emailAddress, idTextController, false),
        SizedBox(
          height: 10.0,
        ),
        _MyTextField('Enter your Password', TextInputType.text, pwTextController, true),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: double.infinity,
          height: 60.0,
          // login page에서만 snack bar가 보일 수 있도록 Builder 추가
          child: Builder(
              builder: (context) {
                return _SignUpButton(context);
              }
          ),
        ),
      ],
    );
  }

  TextField _MyTextField(String hintText, TextInputType type, TextEditingController controller, bool secure) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: type,
      controller: controller,
      obscureText: secure,
    );
  }

  ElevatedButton _SignUpButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[400],
      ),
      onPressed: () async {
        bool isValid = await _createAccount(
          nameTextController.text,
          idTextController.text,
          pwTextController.text,
        );
        if (isValid) {
          Navigator.of(context).pop(isValid);
        }
      },
      child: Text(
        '회원가입',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<bool> _createAccount(String name, String id, String pw) async {
    final duration = 3;
    Account account = Account();

    Tuple2<bool, String> isSuccess = await account.createAccount(name, id, pw);
    if (!isSuccess.item1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isSuccess.item2),
          duration: Duration(seconds: duration),
          backgroundColor: Colors.lightBlue,
        ),
      );
    }

    return isSuccess.item1;
  }
}