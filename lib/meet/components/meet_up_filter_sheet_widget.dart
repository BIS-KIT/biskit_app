import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/provider/meet_up_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetUpFilterSheetWidget extends ConsumerStatefulWidget {
  const MeetUpFilterSheetWidget({super.key});

  @override
  ConsumerState<MeetUpFilterSheetWidget> createState() =>
      _MeetUpFilterSheetWidgetState();
}

class _MeetUpFilterSheetWidgetState
    extends ConsumerState<MeetUpFilterSheetWidget> {
  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(meetUpFilterProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Filter
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 32,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        filterState[index].groupText,
                        style: getTsBody14Sb(context).copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: filterState[index]
                            .filterList
                            .map((e) => ChipWidget(
                                  text: e.text,
                                  isSelected: e.isSeleted,
                                  onClickSelect: () {
                                    ref
                                        .read(meetUpFilterProvider.notifier)
                                        .selectedFilter(filterState[index], e);
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: kColorBorderDefalut,
                    ),
                  );
                },
                itemCount: filterState.length,
              ),
            ),
            // bottom button
          ],
        ),
      ),
    );
  }
}
