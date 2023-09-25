import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // return const CircularProgressIndicator();
    return Center(
      child: Lottie.asset(
        'assets/lottie/loading_lottie.json',
        width: 32,
        height: 32,
      ),
    );
  }
}
