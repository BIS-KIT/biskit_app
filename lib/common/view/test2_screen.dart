import 'package:biskit_app/common/component/full_bleed_button_widget.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/name_birth_gender_screen.dart';
import 'package:biskit_app/user/view/sign_up_university_screen.dart';
import 'package:flutter/material.dart';

class Test2Screen extends StatefulWidget {
  static String get routeName => 'test';
  const Test2Screen({super.key});

  @override
  State<Test2Screen> createState() => _Test2ScreenState();
}

class _Test2ScreenState extends State<Test2Screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Test2 Screen',
      child: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NameBirthGenderScreen(),
                      ));
                },
                child: const FullBleedButtonWidget(
                  text: '다음(이름생일성별)',
                  isEnable: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const UniversityScreen()),
                      ));
                },
                child:
                    const FullBleedButtonWidget(text: '다음(학교)', isEnable: true),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  showDefaultModalBottomSheet(
                    context: context,
                    title: '소속 확인',
                    titleLeftButton: true,
                    titleRightButton: true,
                  );
                },
                child: const Text('BottomSheet'),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
