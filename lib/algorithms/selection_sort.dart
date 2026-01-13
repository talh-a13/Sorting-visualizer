import '../view_models/sorting_view_model.dart';
import 'sorting_algorithm.dart';

class SelectionSort implements SortingAlgorithm {
  @override
  String get title => 'Selection Sort';

  @override
  String get complexity => 'n²';

  @override
  Future<void> sort(SortingViewModel viewModel) async {
    int n = viewModel.numbers.length;

    for (int i = 0; i < n - 1; i++) {
      int minIdx = i;
      if (await viewModel.visualize(pointers: [i], message: 'Finding minimum element from position $i')) return;

      for (int j = i + 1; j < n; j++) {
        if (await viewModel.compare(minIdx, j, message: 'Is ${viewModel.numbers[j]} < ${viewModel.numbers[minIdx]}?')) return;

        if (viewModel.numbers[j] < viewModel.numbers[minIdx]) {
          minIdx = j;
          // Just update text here, no wait needed
          viewModel.setUpdateText('New minimum found: ${viewModel.numbers[minIdx]}');
        }
      }

      if (minIdx != i) {
        if (await viewModel.swapItems(minIdx, i, message: 'Swapping ${viewModel.numbers[minIdx]} and ${viewModel.numbers[i]}')) return;
      }

      viewModel.addSortedElement(i);
    }
    viewModel.addSortedElement(n - 1);
  }
}
