import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/model/notice_model.dart';
import 'package:biskit_app/setting/provider/notice_provider.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class WriteNoticeScreen extends ConsumerStatefulWidget {
  final bool isEditMode;
  final NoticeModel? notice;
  const WriteNoticeScreen({
    Key? key,
    this.isEditMode = false,
    this.notice,
  }) : super(key: key);

  @override
  ConsumerState<WriteNoticeScreen> createState() => _WriteNoticeScreenState();
}

class _WriteNoticeScreenState extends ConsumerState<WriteNoticeScreen> {
  late final FocusNode titleFocusNode;
  late final TextEditingController titleController;
  late final FocusNode contentFocusNode;
  late final TextEditingController contentController;
  String title = '';
  String content = '';
  bool isButtonEnable = false;

  @override
  void initState() {
    super.initState();
    titleFocusNode = FocusNode();
    titleController = TextEditingController();
    contentFocusNode = FocusNode();
    contentController = TextEditingController();
    if (widget.isEditMode) {
      titleController.text = widget.notice!.title;
      title = widget.notice!.title;
      contentController.text = widget.notice!.content;
      content = widget.notice!.content;
    }
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    titleController.dispose();
    contentFocusNode.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> createNotice() async {
    int userId = (ref.watch(userMeProvider) as UserModel).id;
    await ref
        .read(noticeProvider.notifier)
        .createNotice(title: title, content: content, userId: userId);
  }

  void updateNotice() async {
    await ref.read(noticeProvider.notifier).updateNotice(
        noticeId: widget.notice!.id,
        userId: widget.notice!.user.id,
        title: title,
        content: content);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: widget.isEditMode ? '글 수정' : '글쓰기',
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
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () async {
              if (!isButtonEnable) return;
              context.loaderOverlay.show();
              if (widget.isEditMode) {
                updateNotice();
              } else {
                await createNotice();
              }
              if (!mounted) return;
              context.loaderOverlay.hide();
              Navigator.pop(context, true);
            },
            child: Text(
              '저장',
              style: getTsBody16Sb(context).copyWith(
                  color: isButtonEnable
                      ? kColorContentDefault
                      : kColorContentDisabled),
            ),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextInputWidget(
              title: '제목',
              hintText: '제목을 입력해주세요',
              onChanged: (value) {
                title = value;
                if (title.isNotEmpty && content.isNotEmpty) {
                  setState(() {
                    isButtonEnable = true;
                  });
                } else {
                  setState(() {
                    isButtonEnable = false;
                  });
                }
              },
              controller: titleController,
              focusNode: titleFocusNode,
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내용',
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
                      constraints: const BoxConstraints(minHeight: 267),
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
                          content = value;
                          if (title.isNotEmpty && content.isNotEmpty) {
                            setState(() {
                              isButtonEnable = true;
                            });
                          } else {
                            setState(() {
                              isButtonEnable = false;
                            });
                          }
                        },
                        onTap: () {
                          contentFocusNode.requestFocus();
                        },
                        controller: contentController,
                        focusNode: contentFocusNode,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(
                          hintText: '모임설명을 입력해주세요',
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
                      height: 4,
                    ),
                    Text(
                      '${contentController.text.length}/0',
                      style: getTsCaption12Rg(context).copyWith(
                        color: kColorContentWeakest,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
