import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TermsAndPoliciesScreen extends StatefulWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  State<TermsAndPoliciesScreen> createState() => _TermsAndPoliciesScreenState();
}

class _TermsAndPoliciesScreenState extends State<TermsAndPoliciesScreen> {
  List<String> termsAndPolicies = ['서비스 이용약관', '개인정보 처리방침', '오픈소스 라이선스'];
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '약관 및 정책',
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: kColorBorderDefalut,
          ),
        ),
        child: ListView.builder(
          itemCount: termsAndPolicies.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        termsAndPolicies[index],
                        style: getTsBody16Rg(context)
                            .copyWith(color: kColorContentWeak),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SvgPicture.asset(
                      'assets/icons/ic_chevron_right_line_24.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        kColorContentWeakest,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
