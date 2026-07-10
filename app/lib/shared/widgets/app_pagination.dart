import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  const AppPagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.onPageChanged,
    super.key,
  }) : assert(pageSize > 0);

  final int currentPage;
  final int pageSize;
  final int totalItems;
  final ValueChanged<int> onPageChanged;

  int get totalPages {
    if (totalItems == 0) {
      return 1;
    }

    return ((totalItems - 1) ~/ pageSize) + 1;
  }

  int get firstItem {
    if (totalItems == 0) {
      return 0;
    }

    return (currentPage * pageSize) + 1;
  }

  int get lastItem {
    final calculatedLastItem = (currentPage + 1) * pageSize;

    if (calculatedLastItem > totalItems) {
      return totalItems;
    }

    return calculatedLastItem;
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentPage > 0;
    final canGoForward = currentPage < totalPages - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          Text(
            '$firstItem-$lastItem de $totalItems',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          Text(
            'Página ${currentPage + 1} de $totalPages',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Página anterior',
            onPressed: canGoBack
                ? () => onPageChanged(currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            tooltip: 'Próxima página',
            onPressed: canGoForward
                ? () => onPageChanged(currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}