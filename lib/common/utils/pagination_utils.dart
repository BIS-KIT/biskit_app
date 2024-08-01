import 'package:biskit_app/common/provider/pagination_provider.dart';
import 'package:flutter/material.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
    Object? orderBy,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(fetchMore: true, orderBy: orderBy);
    }
  }
}
