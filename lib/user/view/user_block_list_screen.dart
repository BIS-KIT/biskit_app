import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class UserBlockListScreen extends StatefulWidget {
  const UserBlockListScreen({super.key});

  @override
  State<UserBlockListScreen> createState() => _UserBlockListScreenState();
}

class _UserBlockListScreenState extends State<UserBlockListScreen> {
  List<dynamic> users = [
    {'name': '비스킷1', 'value': true},
    {'name': '비스킷2', 'value': true},
    {'name': '비스킷3', 'value': true},
    {'name': '비스킷4', 'value': true},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '차단 사용자 관리',
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      child: users.isNotEmpty
          ? ListView.builder(
              itemCount: 4,
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
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const AvatarWithFlagWidget(
                                  flagPath: null,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  users[index]['name'],
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
                                users = users
                                    .map((user) =>
                                        user['name'] == users[index]['name']
                                            ? {...user, 'value': !user['value']}
                                            : user)
                                    .toList();
                              },
                            );
                          },
                          child: users[index]['value'] == true
                              ? const FilledButtonWidget(
                                  text: '차단중',
                                  isEnable: true,
                                  height: 40,
                                  backgroundColor: kColorBgError,
                                  fontColor: kColorContentError,
                                )
                              : const OutlinedButtonWidget(
                                  text: '차단하기',
                                  isEnable: true,
                                  height: 40,
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
                '차단한 사용자가 없어요',
                style: getTsBody16Rg(context)
                    .copyWith(color: kColorContentWeakest),
              ),
            ),
    );
  }
}
