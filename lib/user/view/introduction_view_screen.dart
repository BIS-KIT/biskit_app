import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/profile/repository/profile_repository.dart';
import 'package:biskit_app/profile/view/profile_keyword_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/repository/users_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class IntroductionViewScreen extends ConsumerStatefulWidget {
  final bool isEditorEnable;
  final String? nickName;
  final int userId;
  const IntroductionViewScreen({
    Key? key,
    this.isEditorEnable = true,
    this.nickName,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<IntroductionViewScreen> createState() =>
      _IntroductionViewScreenState();
}

class _IntroductionViewScreenState
    extends ConsumerState<IntroductionViewScreen> {
  UserModel? userState;
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    userState =
        await ref.read(usersRepositoryProvider).getReadUser(widget.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final userState = ref.watch(userMeProvider);
    return Scaffold(
      backgroundColor: kColorBgElevation2,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              if (userState != null)
                // Appbar
                _buildAppBar(
                  context,
                  (userState as UserModel),
                ),

              // content
              if (userState != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: kColorBgDefault,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
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
                            Text(
                              userState!.profile!.introductions[index].keyword,
                              style: getTsBody16Sb(context).copyWith(
                                color: kColorContentDefault,
                              ),
                            ),
                            if (userState!.profile!.introductions[index].context
                                .isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    userState!
                                        .profile!.introductions[index].context,
                                    style: getTsBody14Rg(context).copyWith(
                                      color: kColorContentWeak,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                      itemCount: userState!.profile!.introductions.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    UserModel userState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 10,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/icons/ic_arrow_back_ios_line_24.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      kColorContentDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.isEditorEnable ? 'myFavoriteScreen.title'.tr() : '',
                  textAlign: TextAlign.center,
                  style: getTsBody16Sb(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
              ),
              widget.isEditorEnable
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileKeywordScreen(
                                introductions: userState.profile!.introductions
                                    .map((e) => KeywordModel(
                                        keyword: e.keyword, context: e.context))
                                    .toList(),
                                isEditorMode: true,
                                userNickName: userState.profile!.nick_name,
                                editorCallback: (keywordList) async {
                                  logger.d(keywordList);
                                  bool isOk = await ref
                                      .read(profileRepositoryProvider)
                                      .updateProfile(
                                    profile_id: userState.profile!.id,
                                    data: {
                                      'introductions': keywordList
                                          .map((x) => {
                                                'keyword': x.keyword,
                                                'context': x.context,
                                              })
                                          .toList(),
                                    },
                                  );
                                  if (isOk) {
                                    ref.read(userMeProvider.notifier).getMe();
                                    await init();
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/icons/ic_pencil_line_24.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            kColorContentDefault,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 44,
                      height: 44,
                    ),
            ],
          ),
        ),
        if (!widget.isEditorEnable)
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
              left: 20,
              bottom: 8,
              right: 20,
            ),
            child: Text(
              '${widget.nickName ?? ''}${'othersFavoriteScreen.title'.tr()}',
              textAlign: TextAlign.left,
              style: getTsHeading20(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
          ),
      ],
    );
  }
}
