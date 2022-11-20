  // ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tmdb/ui/naviagation/main_navigation_action.dart';

class SplashWidget extends StatefulWidget {
  final MainNavigationAction navigationAction;
  const SplashWidget({super.key, required this.navigationAction});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    splash();
  }

  void splash() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 2150));
    widget.navigationAction.resetNavigation(context);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/flutter_logo.json',
              height: 200.0,
              width: 200.0,
            ),
          ],
        ),
      ]),
    );
  }
}
