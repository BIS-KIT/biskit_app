import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/model/model_with_id.dart';
import 'package:biskit_app/common/provider/pagination_provider.dart';
import 'package:biskit_app/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
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

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    this.startScrollIndex,
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
      child: ListView.separated(
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
                    : const Text('더 이상 데이터가 없습니다'),
              ),
            );
          }

          final pItem = cp.data[index];

          return AutoScrollTag(
            key: ValueKey(pItem.uid),
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
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
