import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/chat/model/chat_msg_model.dart';
import 'package:biskit_app/chat/model/chat_room_model.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/date_util.dart';
import 'package:biskit_app/user/model/user_model.dart';

class ChatRoomCardWidget extends StatefulWidget {
  final ChatRoomModel chatRoomModel;
  final UserModel user;
  final ChatRoomFirstUserInfo? chatRoomFirstUserInfo;
  final VoidCallback onTapChatRoom;
  const ChatRoomCardWidget({
    Key? key,
    required this.chatRoomModel,
    required this.user,
    this.chatRoomFirstUserInfo,
    required this.onTapChatRoom,
  }) : super(key: key);

  @override
  State<ChatRoomCardWidget> createState() => _ChatRoomCardWidgetState();
}

class _ChatRoomCardWidgetState extends State<ChatRoomCardWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (details) async {
        setState(() {
          _pressed = false;
        });
        widget.onTapChatRoom();
      },
      // onTap: () {
      //   widget.onTapChatRoom();
      // },
      child: Container(
        padding: const EdgeInsets.all(20),
        color: _pressed ? kColorBgElevation1 : kColorBgDefault,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ThumbnailIconWidget(
              iconPath:
                  widget.chatRoomModel.roomImagePath ?? kCategoryDefaultPath,
              thumbnailIconType: ThumbnailIconType.network,
              isSelected: false,
              radius: 12,
              size: 52,
              iconSize: 44,
              padding: 4,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatRoomModel.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: getTsBody16Sb(context).copyWith(
                      color: kColorContentDefault,
                    ),
                  ),
                  if (widget.chatRoomFirstUserInfo != null &&
                      widget.chatRoomFirstUserInfo!.firstJoinDate != null &&
                      widget.chatRoomModel.lastMsgDate != null &&
                      widget.chatRoomFirstUserInfo!.firstJoinDate
                              .microsecondsSinceEpoch <=
                          widget.chatRoomModel.lastMsgDate
                              .microsecondsSinceEpoch &&
                      ([
                        ChatMsgType.text.name,
                        ChatMsgType.image.name,
                      ].contains(widget.chatRoomModel.lastMsgType)))
                    Text(
                      widget.chatRoomModel.lastMsgType == ChatMsgType.text.name
                          ? widget.chatRoomModel.lastMsg ?? ''
                          : '사진',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: getTsBody14Rg(context).copyWith(
                        color: kColorContentWeaker,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            if (widget.chatRoomFirstUserInfo != null &&
                widget.chatRoomFirstUserInfo!.firstJoinDate != null &&
                widget.chatRoomModel.lastMsgDate != null &&
                widget.chatRoomFirstUserInfo!.firstJoinDate
                        .microsecondsSinceEpoch <=
                    widget.chatRoomModel.lastMsgDate.microsecondsSinceEpoch)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.chatRoomModel.lastMsgDate == null
                        ? ''
                        : getDateTimeToString(
                            widget.chatRoomModel.lastMsgDate.toDate(),
                          ),
                    style: getTsCaption12Rg(context).copyWith(
                      color: kColorContentWeakest,
                    ),
                  ),
                  widget.chatRoomModel.lastMsgUid == null ||
                          widget.chatRoomModel.lastMsgReadUsers
                              .contains(widget.user.id)
                      ? Container()
                      : const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: kColorBgNotification,
                          ),
                        ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
