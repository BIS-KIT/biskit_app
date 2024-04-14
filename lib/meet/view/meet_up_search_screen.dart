import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/meet/components/meet_up_card_widget.dart';
import 'package:biskit_app/meet/provider/meet_up_search_provider.dart';
import 'package:biskit_app/meet/view/meet_up_create_screen.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpSearchScreen extends ConsumerStatefulWidget {
  const MeetUpSearchScreen({super.key});

  @override
  ConsumerState<MeetUpSearchScreen> createState() => _MeetUpSearchScreenState();
}

class _MeetUpSearchScreenState extends ConsumerState<MeetUpSearchScreen>
    with WidgetsBindingObserver {
  late final TextEditingController controller;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = TextEditingController();

    scrollController.addListener(() {
      if (scrollController.offset >
          scrollController.position.maxScrollExtent - 300) {
        ref.read(meetUpSearchProvider.notifier).fetchItems(
              searchWord: controller.text,
            );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  _search() async {
    await ref.read(meetUpSearchProvider.notifier).fetchItems(
          searchWord: controller.text,
          forceRefetch: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(meetUpSearchProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultLayout(
        backgroundColor: kColorBgDefault,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top
              Container(
                // height: 76,
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 12,
                  bottom: 16,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: kColorBgDefault,
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: state.data.isEmpty
                          ? kColorBgDefault
                          : kColorBorderDefalut,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/icons/ic_arrow_back_ios_line_24.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: SearchBarWidget(
                        controller: controller,
                        autofocus: true,
                        hintText: 'searchMeetupScreen.placeholder'.tr(),
                        onChanged: (value) {},
                        onFieldSubmitted: (p0) {
                          _search();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color:
                      state.data.isEmpty ? kColorBgDefault : kColorBgElevation1,
                  child: (state.data.isEmpty && state.meta.totalCount == 0)
                      ? _buildEmpty(context)
                      : ListView.separated(
                          controller: scrollController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          itemBuilder: (context, index) {
                            return MeetUpCardWidget(
                              model: state.data[index],
                              userModel: ref.watch(userMeProvider),
                              systemModel: ref.watch(systemProvider),
                              onTapMeetUp: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MeetUpDetailScreen(
                                      meetupId: state.data[index].id,
                                      userModel: ref.watch(userMeProvider),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 12,
                          ),
                          itemCount: state.data.length,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildEmpty(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: kColorBgElevation1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/images/img_empty_states.png',
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'searchMeetupScreen.noResult'.tr(),
                style: getTsBody16Sb(context).copyWith(
                  color: kColorContentPlaceholder,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 24,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: kColorBgDefault,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'searchMeetupScreen.makeMeetup'.tr(),
                  style: getTsBody14Rg(context).copyWith(
                    color: kColorContentWeaker,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MeetUpCreateScreen(),
                          ),
                        );
                      },
                      child: OutlinedButtonWidget(
                        text: 'searchMeetupScreen.createMeetup'.tr(),
                        height: 44,
                        isEnable: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
