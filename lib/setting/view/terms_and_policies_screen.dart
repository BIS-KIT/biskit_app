import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/view/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TermsAndPoliciesScreen extends StatefulWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  State<TermsAndPoliciesScreen> createState() => _TermsAndPoliciesScreenState();
}

class _TermsAndPoliciesScreenState extends State<TermsAndPoliciesScreen> {
  List<Map<String, String>> termsAndPolicies = [
    {
      'title': '서비스 이용약관',
      'url': kTermsConditionsServiceUseUrl,
    },
    {
      'title': '개인정보 처리방침',
      'url': kPrivacyPolicyUrl,
    },
  ];
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                        url: termsAndPolicies[index]['url'] ?? '',
                        title: termsAndPolicies[index]['title'] ?? ''),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        termsAndPolicies[index]['title'] ?? '',
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
