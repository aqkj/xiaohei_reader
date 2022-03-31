import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
class WelcomePage extends StatefulWidget {
  static final String routeName = '/';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isInit = false;
  @override
  void initState() {
    super.initState();
    print('init');
    _wait();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  void _wait () async {
    await Future.delayed(Duration(
      seconds: 3
    ));
    Navigator.of(context).pushReplacementNamed('/home');
  }
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (BuildContext context, store) {
        return Container(
          child: Image(
            image: AssetImage(
              'static/images/welcome.jpeg'
            ),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}