import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/profile/components/profile_card_widget.dart';
import 'package:biskit_app/review/components/review_card_widget.dart';
import 'package:biskit_app/review/provider/review_provider.dart';
import 'package:biskit_app/review/view/review_view_screen.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/setting/view/report_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileViewScreen extends ConsumerStatefulWidget {
  final int userId;
  const ProfileViewScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends ConsumerState<ProfileViewScreen> {
  UserModel? profileUserModel;
  UserModelBase? userState;
  bool? isBan;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    profileUserModel =
        await ref.read(usersRepositoryProvider).getReadUser(widget.userId);
    await checkBan();
    setState(() {});
  }

  checkBan() async {
    List<int> bans = await ref.read(settingRepositoryProvider).getCheckUserBans(
      user_id: (ref.read(userMeProvider) as UserModel).id,
      target_ids: [widget.userId],
    );
    if (bans.contains(widget.userId)) {
      isBan = true;
    } else {
      isBan = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    userState = ref.watch(userMeProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kColorBgElevation2,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Appbar
            _buildAppbar(context),
            if (profileUserModel != null)
              // content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      ProfileCardWidget(
                        userState: profileUserModel!,
                        isMe: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildReview(size),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(Size size) {
    final reviewState = ref.watch(reviewProvider(profileUserModel!.id));

    if (reviewState.data.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 164,
              child: Center(
                child: Text(
                  '작성된 후기가 없어요',
                  style: getTsBody14Sb(context).copyWith(
                    color: kColorContentWeakest,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      double width = (size.width - 40 - 8) / 2;
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            spacing: 8,
            children: [
              ...reviewState.data
                  .map((e) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewViewScreen(
                                model: e,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: '$kReviewTagName/${e.id}',
                          child: ReviewCardWidget(
                            width: width,
                            imagePath: e.image_url,
                            reviewImgType: ReviewImgType.networkImage,
                            flagCodeList: e.creator.user_nationality
                                .map((e) => e.nationality.code)
                                .toList(),
                            isShowDelete: false,
                            isShowFlag: true,
                            isShowLock: false,
                            isShowLogo: false,
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      );
    }
  }

  Padding _buildAppbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        left: 20,
        bottom: 2,
        right: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '프로필',
              style: getTsHeading20(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
          ),
          (userState != null && userState is UserModel) &&
                  (userState as UserModel).id != widget.userId
              ? GestureDetector(
                  onTap: () {
                    onTapMore();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/icons/ic_more_horiz_line_24.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        kColorContentDefault,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                  ),
                ),
        ],
      ),
    );
  }

  void onTapMore() {
    if (profileUserModel == null) return;

    showMoreBottomSheet(
      context: context,
      list: [
        MoreButton(
          text: '신고하기',
          color: kColorContentError,
          onTap: () async {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportScreen(
                  contentType: ReportContentType.User,
                  contentId: widget.userId,
                ),
              ),
            );
          },
        ),
        if (isBan != null && isBan!)
          MoreButton(
            text: '차단 해제',
            color: kColorContentDefault,
            onTap: () async {
              Navigator.pop(context);
              bool isOk = await ref.read(settingRepositoryProvider).unblockUser(
                    target_id: widget.userId,
                    reporter_id: (userState as UserModel).id,
                  );
              if (isOk && mounted) {
                setState(() {
                  isBan = false;
                });
                showSnackBar(
                  context: context,
                  text: '${profileUserModel!.profile!.nick_name}님을 차단 해제했어요.',
                  margin: const EdgeInsets.only(
                    bottom: 40,
                    left: 12,
                    right: 12,
                  ),
                );
              }
            },
          ),
        if (isBan != null && !isBan!)
          MoreButton(
            text: '차단하기',
            color: kColorContentError,
            onTap: () async {
              Navigator.pop(context);
              bool isOk = await ref.read(settingRepositoryProvider).blockUser(
                    target_id: widget.userId,
                    reporter_id: (userState as UserModel).id,
                  );
              if (isOk && mounted) {
                setState(() {
                  isBan = true;
                });
                showSnackBar(
                  context: context,
                  text: '${profileUserModel!.profile!.nick_name}님을 차단했어요.',
                  margin: const EdgeInsets.only(
                    bottom: 40,
                    left: 12,
                    right: 12,
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
