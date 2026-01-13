import '../view_models/sorting_view_model.dart';
import 'sorting_algorithm.dart';

class BubbleSort implements SortingAlgorithm {
  @override
  String get title => 'Bubble Sort';

  @override
  String get complexity => 'n²';

  @override
  Future<void> sort(SortingViewModel viewModel) async {
    int n = viewModel.numbers.length;
    
    for (int step = 0; step < n; step++) {
      for (int i = 0; i < n - step - 1; i++) {
        // Reduced duplication: compare and swap logic encapsulated
        if (await viewModel.compare(i, i + 1, message: 'Comparing ${viewModel.numbers[i]} and ${viewModel.numbers[i + 1]}')) return;

        if (viewModel.numbers[i] > viewModel.numbers[i + 1]) {
          if (await viewModel.swapItems(i, i + 1, message: '${viewModel.numbers[i]} > ${viewModel.numbers[i + 1]} - Swapping!')) return;
        } else {
           if (await viewModel.visualize(message: '${viewModel.numbers[i]} ≤ ${viewModel.numbers[i + 1]} - No swap')) return;
        }
      }
      viewModel.addSortedElement(n - step - 1);
    }
  }
}
