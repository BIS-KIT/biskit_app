import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/model/report_res_model.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WarningHistoryScreen extends ConsumerStatefulWidget {
  const WarningHistoryScreen({super.key});

  @override
  ConsumerState<WarningHistoryScreen> createState() =>
      _WarningHistoryScreenState();
}

class _WarningHistoryScreenState extends ConsumerState<WarningHistoryScreen> {
  List<ReportResModel>? warningHistories;
  final DateFormat dayFormat = DateFormat('MM/dd hh:mm', 'ko');

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    int userId = (ref.watch(userMeProvider) as UserModel).id;
    List<ReportResModel>? res = await ref
        .read(settingRepositoryProvider)
        .getReportHistory(user_id: userId);
    setState(() {
      warningHistories = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (warningHistories == null) {
      init();
    }
    final size = MediaQuery.of(context).size;

    return DefaultLayout(
      title: 'setWarningScreen.header'.tr(),
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      child: warningHistories == null
          ? const Center(
              child: CustomLoading(),
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: ShapeDecoration(
                      color: kColorBgElevation1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'setWarningScreen.acWarnings'.tr(),
                            style: getTsBody14Sb(context)
                                .copyWith(color: kColorContentWeaker),
                          ),
                        ),
                        Text(
                          '${warningHistories!.length} ${'setWarningScreen.count'.tr()}',
                          style: getTsBody16Sb(context)
                              .copyWith(color: kColorContentWeak),
                        ),
                      ],
                    ),
                  ),
                ),
                warningHistories!.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: warningHistories!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: size.width,
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
                                    vertical: 16, horizontal: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: kColorBgError,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            'assets/images/ic_siren_fill_24.png',
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    SizedBox(
                                      width: size.width - 85,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'setWarningScreen.warning'.tr(),
                                            style: getTsBody14Sb(context)
                                                .copyWith(
                                                    color: kColorContentWeak),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            '${'setWarningScreen.description1'.tr()} ${index + 1} ${'setWarningScreen.count'.tr()} ${'setWarningScreen.description2'.tr()}',
                                            style: getTsBody14Rg(context)
                                                .copyWith(
                                                    color: kColorContentWeak),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            dayFormat.format(DateTime.parse(
                                                warningHistories![index]
                                                    .created_time)),
                                            style: getTsCaption12Rg(context)
                                                .copyWith(
                                                    color:
                                                        kColorContentWeakest),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            'setWarningScreen.noWarnings'.tr(),
                            style: getTsBody16Rg(context)
                                .copyWith(color: kColorContentWeakest),
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}
