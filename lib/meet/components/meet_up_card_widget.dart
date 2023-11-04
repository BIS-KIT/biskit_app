import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';

class MeetUpCardWidget extends StatelessWidget {
  final MeetUpModel model;
  const MeetUpCardWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: kColorBgDefault,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: kColorBgElevation2,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_hobby_fill_48.svg',
                  width: 28,
                  height: 28,
                  colorFilter: const ColorFilter.mode(
                    kColorContentSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_person_fill_24.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      kColorContentWeaker,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        model.current_participants.toString(),
                        style: getTsCaption12Sb(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '/',
                        style: getTsCaption12Rg(context).copyWith(
                          color: kColorContentWeakest,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        model.max_participants.toString(),
                        style: getTsCaption12Rg(context).copyWith(
                          color: kColorContentWeakest,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: kColorBgSecondary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      model.participants_status,
                      style: getTsCaption12Sb(context).copyWith(
                        color: kColorContentInverse,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            model.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getTsBody16Sb(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const CircleAvatar(
                radius: 8,
                backgroundColor: Colors.amber,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                '00/00(월)',
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                '·',
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeakest,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                '오전 0:00',
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                '·',
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeakest,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                model.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          ExtendedWrap(
            spacing: 6,
            runSpacing: 6,
            maxLines: 2,
            children: model.tags
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: kColorBgElevation2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      e.kr_name,
                      style: getTsCaption12Rg(context).copyWith(
                        color: kColorContentWeaker,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
