import 'package:biskit_app/chat/view/chat_room_screen.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/provider/root_provider.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/home_screen.dart';
import 'package:biskit_app/meet/view/meet_up_create_screen.dart';
import 'package:biskit_app/meet/view/meet_up_list_screen.dart';
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
  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 5, vsync: this);

    controller.addListener(tabListener);
    ref.read(rootProvider.notifier).setTabController(controller);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    ref.read(rootProvider.notifier).tabListener(controller.index);
  }

  @override
  Widget build(BuildContext context) {
    final rootState = ref.watch(rootProvider);

    return DefaultLayout(
      backgroundColor: rootState.scafoldBackgroundColor,
      bottomNavigationBar: Container(
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
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                createUpDownRoute(const MeetUpCreateScreen()),
              );
              return;
            } else {
              ref.read(rootProvider.notifier).onTapBottomNav(index);
              // controller.animateTo(index);
            }
          },
          currentIndex: rootState.index,
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
              iconPath: 'assets/icons/ic_chat_line_24.svg',
              label: '채팅',
            ),
            _buildBottomItem(
              iconPath: 'assets/icons/ic_face_line_24.svg',
              label: '프로필',
            ),
          ],
        ),
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          const HomeScreen(),
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
            kColorContentPlaceholder,
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
