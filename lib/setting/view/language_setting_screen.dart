import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSettingScreen extends ConsumerStatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  ConsumerState<LanguageSettingScreen> createState() =>
      _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends ConsumerState<LanguageSettingScreen> {
  String? selectedLang;

  updateUserOSLanguage() async {
    try {
      await ref.read(systemProvider.notifier).updateUserOSLanguage(
            systemId: (ref.watch(systemProvider) as UserSystemModel).id,
            selectedLang: selectedLang,
          );
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedLang == null) {
      setState(() {
        selectedLang =
            (ref.watch(systemProvider) as UserSystemModel).system_language;
      });
    }
    return DefaultLayout(
        title: 'setLangScreen.header'.tr(),
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: kColorBorderDefalut,
          ),
        ),
        onTapLeading: () {
          updateUserOSLanguage();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedLang = 'kr';
                    });
                    await context.setLocale(const Locale('ko', 'KR'));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckCircleWidget(
                          value: selectedLang == 'kr',
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'setLangScreen.korean'.tr(),
                          style: getTsBody16Rg(context)
                              .copyWith(color: kColorContentWeak),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    setState(
                      () {
                        selectedLang = 'en';
                      },
                    );
                    await context.setLocale(const Locale('en', 'US'));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckCircleWidget(
                          value: selectedLang == 'en',
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'setLangScreen.english'.tr(),
                          style: getTsBody16Rg(context)
                              .copyWith(color: kColorContentWeak),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
