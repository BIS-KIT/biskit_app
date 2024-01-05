import 'package:biskit_app/chat/view/chat_room_screen.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/provider/home_provider.dart';
import 'package:biskit_app/common/provider/root_provider.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/home_screen.dart';
import 'package:biskit_app/meet/view/meet_up_create_screen.dart';
import 'package:biskit_app/meet/view/meet_up_list_screen.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/view/my_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class RootTab extends ConsumerStatefulWidget {
  static String get routeName => 'home';
  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  // late TabController controller;
  List<Widget> bodyList = [
    const HomeScreen(),
    const MeetUpListScreen(),
    Container(),
    const ChatRoomScreen(),
    const MyPageScreen(),
  ];

  bool isFirstToolTip = true;

  @override
  void initState() {
    super.initState();

    // controller = TabController(length: 5, vsync: this);

    // controller.addListener(tabListener);
    // ref.read(rootProvider.notifier).setTabController(controller);
  }

  @override
  void dispose() {
    // controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    // ref.read(rootProvider.notifier).tabListener(controller.index);
  }

  @override
  Widget build(BuildContext context) {
    final rootState = ref.watch(rootProvider);
    final userState = ref.watch(userMeProvider);

    return DefaultLayout(
      backgroundColor: rootState.scafoldBackgroundColor,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          decoration: const BoxDecoration(
            color: kColorBgDefault,
            border: Border(
              top: BorderSide(
                width: 1,
                color: kColorBorderWeak,
              ),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            backgroundColor: kColorBgDefault,
            enableFeedback: false,
            type: BottomNavigationBarType.fixed,
            onTap: (index) async {
              if (index == 2) {
                if (isFirstToolTip) {
                  setState(() {
                    isFirstToolTip = false;
                  });
                }
                if (userState != null &&
                    userState is UserModel &&
                    userState.profile != null &&
                    userState.profile!.student_verification == null) {
                  // 인증을 안했을때
                  showConfirmModal(
                    context: context,
                    title: '학교 인증을 하면\n모임을 만들 수 있어요',
                    content: '간단히 인증하고 모임을 만들어보세요.',
                    leftButton: '취소',
                    leftCall: () {
                      Navigator.pop(context);
                    },
                    rightButton: '인증하기',
                    rightBackgroundColor: kColorBgPrimary,
                    rightTextColor: kColorContentOnBgPrimary,
                    rightCall: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileIdConfirmScreen(
                            isEditor: true,
                          ),
                        ),
                      );
                      await ref.read(userMeProvider.notifier).getMe();
                    },
                  );
                } else if (userState != null &&
                    userState is UserModel &&
                    userState.profile != null &&
                    userState.profile!.student_verification!
                            .verification_status ==
                        VerificationStatus.PENDING.name) {
                  showDefaultModal(
                    context: context,
                    title: '학교 인증 승인 대기중',
                    content: '승인 완료된 유저만 모임을 만들 수 있어요. 최대한 빠르게 인증 처리 해드릴게요.',
                    function: () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  // 인증된 상태에는 생성 화면 보여주기
                  final List<dynamic>? result = await Navigator.push(
                    context,
                    createUpDownRoute(const MeetUpCreateScreen()),
                  );

                  logger.d(result);
                  if (result != null && result[0] as bool) {
                    ref.read(homeProvider.notifier).init();
                  }
                }
              } else {
                ref.read(rootProvider.notifier).onTapBottomNav(
                      index: index,
                    );
                // controller.animateTo(index);
              }
            },
            currentIndex: rootState.index,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              _buildBottomItem(
                iconPath: 'assets/icons/ic_home_line_24.svg',
                activeIconPath: 'assets/icons/ic_home_fill_24.svg',
                label: '홈',
              ),
              _buildBottomItem(
                iconPath: 'assets/icons/ic_search_line_24.svg',
                activeIconPath: 'assets/icons/ic_search_fill_24.svg',
                label: '검색',
              ),
              _buildBottomCenterItem(),
              _buildBottomItem(
                iconPath: 'assets/icons/ic_chat_line_24.svg',
                activeIconPath: 'assets/icons/ic_chat_fill_24.svg',
                label: '채팅',
              ),
              _buildBottomItem(
                iconPath: 'assets/icons/ic_face_line_24.svg',
                activeIconPath: 'assets/icons/ic_face_fill_24.svg',
                label: '프로필',
              ),
            ],
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          bodyList[rootState.index],
          if (userState != null &&
              userState is UserModel &&
              userState.profile != null &&
              userState.profile!.student_verification == null &&
              isFirstToolTip)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kColorBgOverlay.withOpacity(0.7),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    '학교 인증하고 모임을 만들어보세요',
                    style: getTsCaption12Rg(context).copyWith(
                      color: kColorContentInverse,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/arrow.svg',
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomCenterItem() {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 17,
        ),
        child: SvgPicture.asset(
          'assets/icons/ic_create_line_24.svg',
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(
            kColorContentWeaker,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: '',
    );
  }

  BottomNavigationBarItem _buildBottomItem({
    required String iconPath,
    required String activeIconPath,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 17,
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(
            kColorContentWeaker,
            BlendMode.srcIn,
          ),
        ),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 17,
        ),
        child: SvgPicture.asset(
          activeIconPath,
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(
            kColorContentDefault,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }
}
