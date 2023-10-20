
import 'package:android/pages/search.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }

}

class _SplashState extends State<Splash>{

  @override
  void initState() {
    super.initState();
    _navigateSearch();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "Splash screen",
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }

  _navigateSearch() async {
    await Future.delayed(Duration(milliseconds: 1500)).then((value) => {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Search()))
    });
  }
}
