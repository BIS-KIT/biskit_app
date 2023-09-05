import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FindPasswordScreen extends ConsumerStatefulWidget {
  static String get routeName => 'findPassword';
  const FindPasswordScreen({super.key});

  @override
  ConsumerState<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends ConsumerState<FindPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      title: 'FindPassword Screen',
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
