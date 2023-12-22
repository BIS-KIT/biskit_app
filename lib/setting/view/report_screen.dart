import 'package:biskit_app/setting/model/report_res_model.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';

// ignore: constant_identifier_names
enum ReportContentType { Meeting, Review, User }

class ReportScreen extends ConsumerStatefulWidget {
  final ReportContentType contentType;
  final int contentId;
  const ReportScreen({
    super.key,
    required this.contentType,
    required this.contentId,
  });

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  late final FocusNode contentFocusNode;
  late final TextEditingController contentController;
  String content = '';

  @override
  void initState() {
    super.initState();
    contentFocusNode = FocusNode();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    contentFocusNode.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '신고하기',
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      leadingIconPath: 'assets/icons/ic_cancel_line_24.svg',
      onTapLeading: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '신고 내용',
                  style: getTsBody14Sb(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 169,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kColorBgElevation1,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(width: 1, color: kColorBgElevation3
                            // contentFocusNode.hasFocus
                            //     ? kColorBorderStronger
                            //     : kColorBgElevation3,
                            ),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            content = value;
                          });
                        },
                        onTap: () {
                          contentFocusNode.requestFocus();
                        },
                        controller: contentController,
                        focusNode: contentFocusNode,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(
                          hintText: '신고내용을 입력해주세요',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: getTsBody16Rg(context).copyWith(
                            color: kColorContentPlaceholder,
                          ),
                        ),
                        style: kTsEnBody16Rg.copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      '누적 신고 횟수가 3회 이상인 유저는 모임 생성 및 참여가 제한됩니다.',
                      style: getTsBody14Rg(context).copyWith(
                        color: kColorContentWeakest,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () async {
                if (content.isEmpty) return;
                FocusScope.of(context).unfocus();
                final UserModelBase? userModelBase = ref.watch(userMeProvider);
                if (userModelBase != null && userModelBase is UserModel) {
                  final ReportResModel? reportResModel = await ref
                      .read(settingRepositoryProvider)
                      .postCreateReport(
                        reason: content,
                        content_type: widget.contentType.name,
                        content_id: widget.contentId,
                        reporter_id: userModelBase.id,
                      );
                  if (reportResModel != null && mounted) {
                    showConfirmModal(
                      context: context,
                      rightCall: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      title: '신고가 접수되었습니다. 검토까지 최대 24시간이 소요됩니다.',
                      rightBackgroundColor: kColorBgPrimary,
                      rightTextColor: kColorContentOnBgPrimary,
                    );
                  }
                }
              },
              child: FilledButtonWidget(
                text: '비스킷팀에게 보내기',
                isEnable: content.isNotEmpty,
                height: 52,
              ),
            )
          ],
        ),
      ),
    );
  }
}
