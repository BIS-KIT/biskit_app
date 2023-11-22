import 'package:biskit_app/common/components/thumbnail_icon_notify_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class WarningHistoryScreen extends StatefulWidget {
  const WarningHistoryScreen({super.key});

  @override
  State<WarningHistoryScreen> createState() => _WarningHistoryScreenState();
}

class _WarningHistoryScreenState extends State<WarningHistoryScreen> {
  List warningHistories = [1, 2, 3];
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '경고 내역',
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                      '누적 경고 횟수',
                      style: getTsBody14Sb(context)
                          .copyWith(color: kColorContentWeaker),
                    ),
                  ),
                  Text(
                    '${warningHistories.length}회',
                    style: getTsBody16Sb(context)
                        .copyWith(color: kColorContentWeak),
                  ),
                ],
              ),
            ),
          ),
          warningHistories.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: warningHistories.length,
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
                              vertical: 16, horizontal: 20),
                          child: Row(
                            children: [
                              const ThumbnailIconNotifyWidget(
                                backgroundColor: kColorBgError,
                                iconColor: kColorContentError,
                                // TODO: siren icon 으로 변경해야함
                                iconUrl:
                                    'assets/icons/ic_megaphone_fill_24.svg',
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '경고',
                                    style: getTsBody14Sb(context)
                                        .copyWith(color: kColorContentWeak),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    '서비스 이용규정 위반으로 경고가 3회 누적되었습니다.',
                                    style: getTsBody14Rg(context)
                                        .copyWith(color: kColorContentWeak),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '11/2 17:00',
                                    style: getTsCaption12Rg(context)
                                        .copyWith(color: kColorContentWeakest),
                                  ),
                                ],
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
                      '경고 내역이 없어요',
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
