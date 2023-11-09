import 'package:flutter/material.dart';
import 'package:youfone_app/styles/colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double loadingBallSize = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.center,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween(begin: 0, end: loadingBallSize),
        onEnd: () {
          setState(() {
            if (loadingBallSize == 1) {
              loadingBallSize = 1.5;
            } else {
              loadingBallSize = 1;
            }
          });
        },
        builder: (_, value, __) => Transform.scale(
          scale: value,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: youfoneColor.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
