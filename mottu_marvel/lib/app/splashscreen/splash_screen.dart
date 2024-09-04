import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

import 'fade_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  late final GifController gifController;

  @override
  void initState() {
    super.initState();
    gifController = GifController(vsync: this);
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    animation = Tween<double>(begin: 0, end: 1.0).animate(animationController);
  }

  void _runAnimationAndNavigate() {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        gifController.forward();
      }
    });
    gifController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final navigator = Navigator.of(context);
        await Future.delayed(const Duration(microseconds: 700));
        navigator.pushReplacement(FadeInRoute(routeName: '/home'));
      }
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      await Future.delayed(const Duration(seconds: 1));
      _runAnimationAndNavigate();
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset('lib/design_system/assets/logo.png'),
              ),
              AnimatedBuilder(
                animation: animation,
                builder: (_, __) => Positioned(
                  bottom: 200,
                  child: Opacity(
                    opacity: animation.value,
                    child: Gif(
                      image: const AssetImage('lib/design_system/assets/snap.gif'),
                      controller: gifController,
                      width: 160,
                      height: 160,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
