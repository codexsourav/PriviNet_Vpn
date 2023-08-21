import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:vpn_basic_project/screens/Home_Page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final LocalStorage storage = new LocalStorage('privinet');
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    storage.ready.then((value) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(),
                      Column(
                        children: [
                          Text(
                            'PriviNet',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Loto'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'VPN',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Color.fromARGB(113, 255, 255, 255),
                                fontFamily: 'Loto'),
                          ),
                        ],
                      ),
                      Text(
                        'Made In India',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(158, 255, 255, 255),
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Loto',
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
