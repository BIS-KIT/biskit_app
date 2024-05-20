import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/model/blocked_user_list_model.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserBlockListScreen extends ConsumerStatefulWidget {
  const UserBlockListScreen({super.key});

  @override
  ConsumerState<UserBlockListScreen> createState() =>
      _UserBlockListScreenState();
}

class _UserBlockListScreenState extends ConsumerState<UserBlockListScreen> {
  BlockedUserListModel? blockedIdList;
  List<int> unblockedIdList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    int userId = (ref.watch(userMeProvider) as UserModel).id;
    BlockedUserListModel? res = await ref
        .read(settingRepositoryProvider)
        .getBlockedUserList(userId: userId);
    setState(() {
      blockedIdList = res;
    });
  }

  Future<void> unblockUser() async {
    await ref
        .read(settingRepositoryProvider)
        .unblockBanIds(ban_ids: unblockedIdList);
  }

  @override
  Widget build(BuildContext context) {
    if (blockedIdList == null) {
      init();
    }
    return DefaultLayout(
      title: 'setBlockScreen.header'.tr(),
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      onTapLeading: () {
        if (unblockedIdList.isNotEmpty) {
          unblockUser();
        }
        Navigator.pop(context);
      },
      child: blockedIdList == null
          ? const Center(
              child: CustomLoading(),
            )
          : blockedIdList!.ban_list.isNotEmpty
              ? ListView.builder(
                  itemCount: blockedIdList!.ban_list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: kColorBorderWeak,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    AvatarWithFlagWidget(
                                      profilePath: blockedIdList!
                                          .ban_list[index].target.profile_photo,
                                      flagPath:
                                          '$kS3HttpUrl$kS3Flag43Path/${blockedIdList!.ban_list[index].target.user_nationality[0].nationality.code}.svg',
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      blockedIdList!
                                          .ban_list[index].target.nick_name,
                                      style: getTsBody16Rg(context)
                                          .copyWith(color: kColorContentWeak),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    if (unblockedIdList.contains(
                                        blockedIdList!.ban_list[index].id)) {
                                      setState(
                                        () {
                                          unblockedIdList = unblockedIdList
                                              .where((element) =>
                                                  element !=
                                                  blockedIdList!
                                                      .ban_list[index].id)
                                              .toList();
                                        },
                                      );
                                    } else {
                                      unblockedIdList.add(
                                          blockedIdList!.ban_list[index].id);
                                    }
                                  },
                                );
                              },
                              child: unblockedIdList.contains(
                                      blockedIdList!.ban_list[index].id)
                                  ? OutlinedButtonWidget(
                                      text: 'setBlockScreen.block'.tr(),
                                      isEnable: true,
                                      height: 40,
                                    )
                                  : FilledButtonWidget(
                                      text: 'setBlockScreen.blocked'.tr(),
                                      isEnable: true,
                                      height: 40,
                                      backgroundColor: kColorBgError,
                                      fontColor: kColorContentError,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'setBlockScreen.noUser'.tr(),
                    style: getTsBody16Rg(context)
                        .copyWith(color: kColorContentWeakest),
                  ),
                ),
    );
  }
}
