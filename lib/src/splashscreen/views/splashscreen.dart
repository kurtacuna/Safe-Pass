import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safepass_frontend/common/assets/images.dart';
import 'package:safepass_frontend/common/const/kroutes.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  bool _visible = false;
  
  void _navigator() async {
    await Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        GoRouter.of(context).go(AppRoutes.kAuth);
      }
    });
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..forward();
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(0, -0.5),
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(
    parent: _controller, 
    curve: Curves.easeOut
  ));

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      }); 
    });
    _navigator();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          child: SlideTransition(
            position: _offsetAnimation,
            child: Image.asset(
              AppImages.logoDark,
              height: 200
            )
          ),
        )
      )
    );
  }
}