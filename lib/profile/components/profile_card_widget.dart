import 'dart:math';

import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/new_badge_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/profile/components/language_card_widget.dart';
import 'package:biskit_app/profile/components/use_language_modal_widget.dart';
import 'package:biskit_app/profile/model/student_verification_model.dart';
import 'package:biskit_app/profile/view/profile_edit_screen.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/view/introduction_view_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileCardWidget extends StatelessWidget {
  final UserModel userState;
  final bool isMe;
  const ProfileCardWidget({
    Key? key,
    required this.userState,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: kColorBgDefault,
        boxShadow: [
          BoxShadow(
            color: Color(0x11495B7D),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x07495B7D),
            blurRadius: 1,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile and Language
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: kColorBgElevation1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AvatarWithFlagWidget(
                      radius: 32,
                      flagRadius: 20,
                      profilePath: userState.profile!.profile_photo,
                      flagPath: userState.user_nationality.isEmpty
                          ? null
                          : '$kS3HttpUrl$kS3Flag43Path/${userState.user_nationality[0].nationality.code}.svg',
                    ),

                    // Language card
                    GestureDetector(
                      onTap: () {
                        onTapLangCard(context, userState);
                      },
                      child: LanguageCardWidget(
                        langList: userState.profile!.available_languages,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                // Name area
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Name and gender
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            userState.profile!.nick_name,
                            style: getTsHeading20(context).copyWith(
                              color: kColorContentDefault,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: kColorBgElevation2,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          child: SvgPicture.asset(
                            userState.gender == 'female'
                                ? 'assets/icons/ic_female_line_24.svg'
                                : 'assets/icons/ic_male_line_24.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              kColorContentWeaker,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    // SubText area
                    Builder(builder: (context) {
                      if (isMe) {
                        StudentVerificationModel? studentVerification =
                            userState.profile!.student_verification;
                        if (studentVerification != null &&
                            studentVerification.verification_status !=
                                VerificationStatus.REJECTED.name) {
                          if (studentVerification.verification_status ==
                              VerificationStatus.APPROVE.name) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Wrap(
                                  spacing: 4,
                                  children: [
                                    Text(
                                      context.locale.languageCode == 'en'
                                          ? userState.user_nationality[0]
                                              .nationality.en_name
                                          : userState.user_nationality[0]
                                              .nationality.kr_name,
                                      style: getTsBody14Sb(context).copyWith(
                                        color: kColorContentWeaker,
                                      ),
                                    ),
                                    Text(
                                      '·',
                                      style: getTsBody14Rg(context).copyWith(
                                        color: kColorContentWeakest,
                                      ),
                                    ),
                                    Text(
                                      context.locale.languageCode == 'en'
                                          ? userState.profile!.user_university
                                              .university.en_name
                                          : userState.profile!.user_university
                                              .university.kr_name,
                                      style: getTsBody14Rg(context).copyWith(
                                        color: kColorContentWeaker,
                                      ),
                                    ),
                                    Text(
                                      '${userState.profile!.user_university.department} ${userState.profile!.user_university.education_status}',
                                      style: getTsBody14Rg(context).copyWith(
                                        color: kColorContentWeaker,
                                      ),
                                    ),
                                  ],
                                ),
                                if (userState.profile!.context != null &&
                                    userState.profile!.context!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      userState.profile!.context!,
                                      style: getTsBody14Rg(context).copyWith(
                                        color: kColorContentWeaker,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          } else if (studentVerification.verification_status ==
                              VerificationStatus.PENDING.name) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'myPageScreen.pending'.tr(),
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeaker,
                                  ),
                                ),
                                if (userState.profile!.context != null &&
                                    userState.profile!.context!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      userState.profile!.context!,
                                      style: getTsBody14Rg(context).copyWith(
                                        color: kColorContentWeaker,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'myPageScreen.verificationRequired'.tr(),
                                style: getTsBody14Rg(context).copyWith(
                                  color: kColorContentWeaker,
                                ),
                              ),
                              if (userState.profile!.context != null &&
                                  userState.profile!.context!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    userState.profile!.context!,
                                    style: getTsBody14Rg(context).copyWith(
                                      color: kColorContentWeaker,
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileIdConfirmScreen(
                                        isEditor: true,
                                      ),
                                    ),
                                  );
                                },
                                child: FilledButtonWidget(
                                  text: 'myPageScreen.verifyUniv'.tr(),
                                  height: 40,
                                  isEnable: true,
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 4,
                              children: [
                                Text(
                                  context.locale.languageCode == 'en'
                                      ? userState.user_nationality[0]
                                          .nationality.en_name
                                      : userState.user_nationality[0]
                                          .nationality.kr_name,
                                  style: getTsBody14Sb(context).copyWith(
                                    color: kColorContentWeaker,
                                  ),
                                ),
                                Text(
                                  '·',
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeakest,
                                  ),
                                ),
                                Text(
                                  context.locale.languageCode == 'en'
                                      ? userState.profile!.user_university
                                          .university.en_name
                                      : userState.profile!.user_university
                                          .university.kr_name,
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeaker,
                                  ),
                                ),
                                Text(
                                  '${userState.profile!.user_university.department} ${userState.profile!.user_university.education_status}',
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeaker,
                                  ),
                                ),
                              ],
                            ),
                            if (userState.profile!.context != null &&
                                userState.profile!.context!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  userState.profile!.context!,
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeaker,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                      return Container();
                    }),
                  ],
                ),
              ],
            ),
          ),

          // Badge group
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroductionViewScreen(
                      isEditorEnable: isMe,
                      nickName: userState.profile!.nick_name,
                      userId: userState.id,
                    ),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      children: [
                        // Badge
                        ...userState.profile!.introductions
                            .map(
                              (e) => NewBadgeWidget(
                                size: BadgeSize.L,
                                type: BadgeType.teritary,
                                text: e.keyword,
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Transform.rotate(
                    angle: -90 * pi / 180,
                    child: SvgPicture.asset(
                      'assets/icons/ic_chevron_down_line_24.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        kColorContentWeakest,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          if (isMe)
            // btn
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 20,
                right: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEditScreen(
                        profile: userState.profile!,
                        user_university: userState.profile!.user_university,
                      ),
                    ),
                  );
                },
                child: OutlinedButtonWidget(
                  text: 'myPageScreen.editProfile'.tr(),
                  height: 40,
                  isEnable: true,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void onTapLangCard(BuildContext context, UserModel userState) {
    showDialog(
      context: context,
      builder: (context) {
        return UseLanguageModalWidget(
          available_languages: userState.profile!.available_languages,
        );
      },
    );
  }
}
