import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey.shade500,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 26,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tickets),
            label: '이용권',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity_rounded),
            label: 'My',
          ),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(userMeProvider.notifier).logout();
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
          ),
          Container(),
          Container(),
        ],
      ),
    );
  }
}
