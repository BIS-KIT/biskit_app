import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/model/model_with_id.dart';
import 'package:biskit_app/common/provider/pagination_provider.dart';
import 'package:biskit_app/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  final int? startScrollIndex;
  final Widget? emptyDataWidget;
  final Widget? separatorWidget;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? scrollUp;
  final VoidCallback? scrollDown;
  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    this.startScrollIndex,
    this.emptyDataWidget,
    this.separatorWidget,
    this.padding,
    this.scrollDown,
    this.scrollUp,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final AutoScrollController controller = AutoScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.startScrollIndex != null) {
      controller.scrollToIndex(
        widget.startScrollIndex!,
        preferPosition: AutoScrollPosition.begin,
      );
    }
    controller.addListener(listener);
  }

  void listener() {
    // logger
    //     .d(controller.position.userScrollDirection == ScrollDirection.forward);
    // logger.d(controller.offset);
    if (controller.position.userScrollDirection == ScrollDirection.forward &&
        widget.scrollUp != null) {
      // 스크롤 Up 시
      widget.scrollUp!();
    }
    if (controller.position.userScrollDirection == ScrollDirection.reverse &&
        widget.scrollDown != null) {
      // 스크롤 Down 시
      widget.scrollDown!();
    }
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 완전 처음 로딩일때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CustomLoading(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
            child: const Text(
              '다시시도',
            ),
          ),
        ],
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = state as CursorPagination<T>;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(widget.provider.notifier).paginate(
              forceRefetch: true,
            );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (cp.meta.totalCount == 0)
            widget.emptyDataWidget ??
                Text(
                  '데이터가 없습니다',
                  style: getTsCaption12Rg(context).copyWith(
                    color: kColorContentWeaker,
                  ),
                ),
          ListView.separated(
            padding: widget.padding,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller,
            itemCount: cp.data.length + 1,
            itemBuilder: (_, index) {
              if (index == cp.data.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Center(
                    child: cp is CursorPaginationFetchingMore
                        ? const CustomLoading()
                        : cp.meta.totalCount != 0
                            ? Text(
                                '더 이상 데이터가 없습니다',
                                style: getTsCaption12Rg(context).copyWith(
                                  color: kColorContentWeaker,
                                ),
                              )
                            : Container(),
                  ),
                );
              }

              final pItem = cp.data[index];

              return AutoScrollTag(
                key: ValueKey(pItem.id),
                controller: controller,
                index: index,
                child: widget.itemBuilder(
                  context,
                  index,
                  pItem,
                ),
              );
            },
            separatorBuilder: (_, index) {
              return widget.separatorWidget ?? const SizedBox(height: 16.0);
            },
          ),
        ],
      ),
    );
  }
}
