import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/model/notice_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final NoticeModel notice;
  const AnnouncementDetailScreen({
    Key? key,
    required this.notice,
  }) : super(key: key);

  @override
  State<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  final DateFormat dateFormat = DateFormat('yyyy.MM.dd', 'ko');

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '공지사항',
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      backgroundColor: kColorBgElevation1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: kColorBorderDefalut,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.notice.title,
                    style: getTsHeading18(context)
                        .copyWith(color: kColorContentWeak),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    dateFormat
                        .format(DateTime.parse(widget.notice.created_time)),
                    style: getTsBody14Rg(context)
                        .copyWith(color: kColorContentWeakest),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.notice.content,
              style: getTsBody16Rg(context).copyWith(color: kColorContentWeak),
            ),
          ),
        ],
      ),
    );
  }
}
