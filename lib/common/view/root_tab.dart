import 'dart:io';

import 'package:biskit_app/chat/view/chat_room_screen.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/meet/view/meet_up_create_screen.dart';
import 'package:biskit_app/meet/view/meet_up_list_screen.dart';
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
  int index = 0;
  late TabController controller;
  Color scafoldBackgroundColor = kColorBgElevation2;
  // final DateFormat dayFormat = DateFormat('MM월 dd일', 'ko');

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 5, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
      if (index == 3) {
        scafoldBackgroundColor = kColorBgDefault;
      } else {
        scafoldBackgroundColor = kColorBgElevation2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    // logger.d((userState as UserModel).toJson());
    return DefaultLayout(
      backgroundColor: scafoldBackgroundColor,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: Platform.isIOS ? 28 : 0,
          // left: 8,
          // right: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: kColorBorderWeak,
            width: 1,
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          backgroundColor: kColorBgDefault,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MeetUpCreateScreen(),
                ),
              );
              return;
            } else {
              controller.animateTo(index);
            }
          },
          currentIndex: index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            _buildBottomItem(
              iconPath: 'assets/icons/ic_home_fill_24.svg',
              label: '홈',
            ),
            _buildBottomItem(
              iconPath: 'assets/icons/ic_search_line_24.svg',
              label: '검색',
            ),
            _buildBottomCenterItem(),
            _buildBottomItem(
              iconPath: 'assets/icons/ic_chat_fill_24.svg',
              label: '채팅',
            ),
            _buildBottomItem(
              iconPath: 'assets/icons/ic_person_fill_24.svg',
              label: '프로필',
            ),
          ],
        ),
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          userState is UserModel
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: const AssetImage(
                        'assets/images/88.png',
                      ),
                      foregroundImage: userState.profile!.profile_photo == null
                          ? null
                          : NetworkImage(
                              '${(userState).profile!.profile_photo}',
                            ),
                    ),
                    Text('userId : ${(userState).id}'),
                    Text('email : ${(userState).email}'),
                    Text('snsType : ${(userState).sns_type}'),
                    Text('nickname : ${(userState).profile!.nick_name}'),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(userMeProvider.notifier).deleteUser();
                      },
                      child: const Text(
                        'Delete User',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(userMeProvider.notifier).logout();
                      },
                      child: const Text(
                        'Logout',
                      ),
                    ),
                  ],
                )
              : Container(),
          // userState is UserModel ? _buildGroupTap(userState) : Container(),
          const MeetUpListScreen(),
          Container(),
          const ChatRoomScreen(),
          const MyPageScreen(),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomCenterItem() {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kColorBgPrimary,
        ),
        child: SvgPicture.asset(
          'assets/icons/ic_plus_line_24.svg',
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            kColorContentOnBgPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: '',
    );
  }

  BottomNavigationBarItem _buildBottomItem({
    required String iconPath,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(
            kColorContentPlaceholder,
            BlendMode.srcIn,
          ),
        ),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: SvgPicture.asset(
          iconPath,
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
